//
//  RemotePointOfInterestLoaderWithCachedData.swift
//  FindPlaces
//
//  Created by Branimir Markovic on 13.8.22..
//

import Foundation

final private class LocalPointOfInterestPaths {
    static let pointsOfInterestPath = "PointsOfInterestDirectory/db.json"
}

final private class LocalPointOfInterestMapper {
    static func map(data: Data) throws -> LocalRoot {
            let object = try JSONDecoder().decode(LocalRoot.self, from: data)
        return object
    }
}


class RemotePointOfInterestLoaderWithCachedData: PointsOfInterestLoader {
    
    
    private let remotePointOfInterestLoader: RemotePointsOfInterestLoader
    private let localDataManager: LocalDataManager
    private let cachePolicy: DataCachePolicy
    
    init(remotePointOfInterestLoader: RemotePointsOfInterestLoader, localDataManager: LocalDataManager, cachePolicy: DataCachePolicy) {
        self.remotePointOfInterestLoader = remotePointOfInterestLoader
        self.localDataManager = localDataManager
        self.cachePolicy = cachePolicy
    }
    
    
    func load(placeType: String, orderBy: OrderOptions, completion: @escaping (Result<PointsOfInterestTuple, Error>) -> Void) {
        
        localDataManager.read(from:LocalPointOfInterestPaths.pointsOfInterestPath) { [weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let data):
                do {
                    let rootObject = try LocalPointOfInterestMapper.map(data: data)
                    if self.cachePolicy.isDataValid(of: rootObject) {
                        completion(.success(rootObject.toPOITuple()))
                    } else {
                        self.remotePointOfInterestLoader.load(placeType: placeType, orderBy: orderBy, completion: completion)
                    }
                } catch { completion(.failure(error))}
            case .failure(_):
                self.remotePointOfInterestLoader.load(placeType: placeType, orderBy: orderBy, completion: completion)
            }
        }
        
    }
    
    
    
    
    
}

fileprivate struct  LocalRoot: Decodable, TimeValidable {
    var results: [LocalPOI] 
    var timeStamp: Date
    
    func toPOITuple() -> PointsOfInterestTuple {
        (results.map{$0.toPlace()}, false)
    }
}

fileprivate struct LocalPOI: Decodable {
    var id: String
    var name: String
    var coordinates: LocalCoordinates
    var score: Double
    var price_tier: Int?
    var intro: String
    var tags: [LocalTagObject]
    var images: [LocalPlaceImage]
    
    func toPlace() -> PointOfInterest {
        let images = self.images.map { image in 
            PlaceImageURL(thumbnailURL: image.sizes.thumbnail.url,
                          mediumURL: image.sizes.medium.url,
                          originalURL: image.sizes.original.url)}
        return PointOfInterest(id: self.id,
                     name: self.name,
                     coordinates: self.coordinates.toCoordinates(),
                     score: self.score,
                     intro: self.intro,
                     tags: self.tags.map {$0.tag.toTag()}, 
                     imageURLs: images)
    }
}

fileprivate struct LocalTagObject: Decodable {
    var tag: LocalTag
}

fileprivate struct LocalTag: Decodable {
        var name: String
        var label: String
        var score: Double
        var poi_count: Int
    
    func toTag() -> Tag {
        Tag(name: self.name, label: self.label, score: self.score, pointOfInterestCount: self.poi_count)
    }
}

fileprivate struct LocalCoordinates: Decodable {
    var latitude: Double
    var longitude: Double
    
    func toCoordinates() -> Coordinates {
        Coordinates(latitude: latitude, longitude: longitude)
    }
}

fileprivate struct LocalPlaceImage: Decodable {
    var sizes: LocalImageSizes
}

fileprivate struct LocalImageSizes: Decodable {
    var thumbnail: LocalImageURL
    var medium: LocalImageURL
    var original: LocalImageURL
}

fileprivate struct LocalImageURL: Decodable {
    var url: String
}


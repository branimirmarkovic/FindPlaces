//
//  RemotePlaceLoader.swift
//  FindPlaces
//
//  Created by Branimir Markovic on 7.8.22..
//

import Foundation

fileprivate final class RemotePlacesPathProvider {
    static func places(tagLabel: String, latitude: Double, longitude: Double, distance: Int, orderBy: OrderOptions) -> String {
        "poi.json?tag_labels=\(tagLabel)&count=25&fields=id,name,score,price_tier,coordinates,intro,tags,images&order_by=\(orderBy.rawValue)&annotate=distance:\(latitude),\(longitude)&distance=<\(distance)"
    }
}

fileprivate final class RemotePLacesMapper {
    static func map(data: Data) throws ->  PointsOfInterestTuple {
        do {
            let object = try JSONDecoder().decode(RemoteRoot.self, from: data)
            return object.toResult()
        } catch { throw error}
    }
}

fileprivate extension HTTPClient {
    var placesHeaders: [String: String] {
            ["Content-Type" : "application/json; charset=utf-8",
             "Accept": "application/json; charset=utf-8",
             "X-Triposo-Account": AuthorizationCenter.triposoAccount,
             "X-Triposo-Token":AuthorizationCenter.triposoToken]
    }
}


class RemotePointsOfInterestLoader: PointsOfInterestLoader {
    
    enum Error: Swift.Error {
        case cannotRetrieveUserLocation
        case clientError
        case noData
        case decodingError
    }
    
    private let client: HTTPClient
    private let locationManager: LocationManager
    
    init(client: HTTPClient, locationManager: LocationManager) {
        self.client = client
        self.locationManager = locationManager
    }
    
    
    private var searchDistance: Int {
        5000
    }
    
    func load(placeType: String, orderBy: OrderOptions, completion: @escaping (Result<PointsOfInterestTuple, Swift.Error>) -> Void) {
        locationManager.currentLocation { [weak self] result in
            guard let self = self else {return}
            switch result {
            case.success(let location):
                let relativePath = RemotePlacesPathProvider.places(tagLabel: placeType, latitude: location.coordinate.latitude, longitude: location.coordinate.longitude, distance: self.searchDistance, orderBy: orderBy)
                let request = DefaultHTTPClient.URLHTTPRequest(
                    relativePath: relativePath,
                    body: nil,
                    headers: self.client.placesHeaders,
                    method: .get)

                self.client.request(request: request) { result in
                    switch result {
                    case .success(let data):
                        guard let data = data else {
                            return completion(.failure(Error.noData))
                        }
                        do {
                            let places = try RemotePLacesMapper.map(data: data)
                            completion(.success(places))
                        } catch {completion(.failure(Error.decodingError))}
                    case.failure(_):
                        completion(.failure(Error.clientError))
                    }
                }
            case .failure(_):
                completion(.failure(Error.cannotRetrieveUserLocation))
            }
        }
    }
}



fileprivate struct  RemoteRoot: Decodable{
    var results: [RemotePlace] 
    var more: Bool
    
    func toResult() -> PointsOfInterestTuple {
        (results.map{$0.toPlace()}, more)
    }
}

fileprivate struct RemotePlace: Decodable {
    var id: String
    var name: String
    var coordinates: RemoteCoordinates
    var score: Double
    var price_tier: Int?
    var intro: String
    var tags: [RemoteTagObject]
    var images: [RemotePlaceImage]
    
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

fileprivate struct RemoteTagObject: Decodable {
    var tag: RemoteTag
}

fileprivate struct RemoteTag: Decodable {
        var name: String
        var label: String
        var score: Double
        var poi_count: Int
    
    func toTag() -> Tag {
        Tag(name: self.name, label: self.label, score: self.score, pointOfInterestCount: self.poi_count)
    }
}

fileprivate struct RemoteCoordinates: Decodable {
    var latitude: Double
    var longitude: Double
    
    func toCoordinates() -> Coordinates {
        Coordinates(latitude: latitude, longitude: longitude)
    }
}

fileprivate struct RemotePlaceImage: Decodable {
    var sizes: RemoteImageSizes
}

fileprivate struct RemoteImageSizes: Decodable {
    var thumbnail: RemoteImageSize
    var medium: RemoteImageSize
    var original: RemoteImageSize
}

fileprivate struct RemoteImageSize: Decodable {
    var url: String
}

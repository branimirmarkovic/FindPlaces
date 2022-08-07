//
//  RemoteTagLoader.swift
//  FindPlaces
//
//  Created by Branimir Markovic on 3.8.22..
//

import Foundation
import CoreLocation




fileprivate final class RemoteTagPathProvider {
    static func tags(cityLabelName: String ) -> String {
        "tag.json?location_id=\(cityLabelName)&order_by=-score&count=25&fields=name,poi_count,score,label"
    }
}

fileprivate final class RemoteTagsMapper {
    static func decodeTagsData(_ data: Data) throws -> TagsTuple {
        do {
            let object = try JSONDecoder().decode(RemoteTagRootObject.self, from: data)
            return object.toTagsTuple()
        } catch { throw error }
    }
}

fileprivate extension HTTPClient {
     var tagClientHeaders: [String : String] {
        ["Content-Type" : "application/json; charset=utf-8",
         "Accept": "application/json; charset=utf-8",
         "X-Triposo-Account": AuthorizationCenter.triposoAccount,
         "X-Triposo-Token":AuthorizationCenter.triposoToken]
    }
}


class RemoteTagLoader: TagsLoader {
    
    enum Error: Swift.Error {
        case cannotRetrieveUserLocation
        case errorLoadingNearbyTriposoLocations
        case noNearbyLocations
        case clientError
        case noData
        case decodingError
    }
    
    private let client: HTTPClient
    private let locationManager: LocationManager
    private let triposoLocationsLoader: TriposoLocationsLoader
    
    init(client: HTTPClient, locationManager: LocationManager, triposloLocationsLoader: TriposoLocationsLoader) {
        self.client = client
        self.locationManager = locationManager
        self.triposoLocationsLoader = triposloLocationsLoader
    }
    
    
    func load(completion: @escaping (Result<TagsTuple, Swift.Error>) -> Void) {
        locationManager.currentLocation(completion: { [weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let currentLocation):
                let coordinates = Coordinates(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude)
                self.triposoLocationsLoader.loadLocations (currentLocation: coordinates) { [weak self] result in
                    guard let self = self else {return}
                    switch result {
                    case .success(let locations):
                        guard let location = locations.first else {
                            completion(.failure(Self.Error.noNearbyLocations))
                            return
                        }
                        let request = DefaultHTTPClient.URLHTTPRequest (
                            relativePath: RemoteTagPathProvider.tags(cityLabelName: location.id),
                            body: nil,
                            headers: self.client.tagClientHeaders,
                            method: .get) 
                        
                        self.client.request(request: request) {  result in
                            switch result {
                            case .success(let data):
                                guard let data = data else {return completion(.failure(Error.noData))}
                                do {
                                    let tags = try RemoteTagsMapper.decodeTagsData(data)
                                    completion(.success(tags))
                                } catch {
                                    completion(.failure(Error.decodingError))
                                }
                            case .failure(_):
                                completion(.failure(Error.clientError))
                            }
                        }
                    case.failure(let error):
                        completion(.failure(Error.errorLoadingNearbyTriposoLocations))
                    }
                }
            case .failure(_):
                completion(.failure(Error.cannotRetrieveUserLocation))
            }
        })
    }
}



fileprivate struct RemoteTagRootObject: Decodable {
        var results: [RemoteTag] 
        var more: Bool
    
    func toTagsTuple() -> TagsTuple {
        (results.map {$0.toTag()},more)
    }
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


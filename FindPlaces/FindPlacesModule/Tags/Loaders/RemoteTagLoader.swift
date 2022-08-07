//
//  RemoteTagLoader.swift
//  FindPlaces
//
//  Created by Branimir Markovic on 3.8.22..
//

import Foundation
import CoreLocation


protocol TriposoLocationsLoader {
    func loadLocations(currentLocation: CLLocation, completion: @escaping (Result<Locations,Error>) -> Void)
}

fileprivate final class RemoteTagPathProvider {
   static func tags(cityLabelName: String ) -> String {
        "tag.json?location_id=\(cityLabelName)&order_by=-score&count=25&fields=name,poi_count,score,label"
    }
}

fileprivate final class RemoteTagsMapper {
     static func decodeTagsData(_ data: Data?) throws -> Tags {
        guard let data = data else { throw NSError(domain: "No Data", code: 0, userInfo: nil)}
        return try JSONDecoder().decode(Tags.self, from: data)
    }
}


class RemoteTagLoader: TagsLoader {
    
    enum Error: Swift.Error {
        case cannotRetrieveUserLocation
        case errorLoadingNearbyTriposoLocations
        case noNearbyLocations
        case clientError
    }
    
    private let client: HTTPClient
    private let locationManager: LocationManager
    private let triposoLocationsLoader: TriposoLocationsLoader
    
    init(client: HTTPClient, locationManager: LocationManager, triposloLocationsLoader: TriposoLocationsLoader) {
        self.client = client
        self.locationManager = locationManager
        self.triposoLocationsLoader = triposloLocationsLoader
    }
    
    private var clientHeaders: [String : String] {
        ["Content-Type" : "application/json; charset=utf-8",
         "Accept": "application/json; charset=utf-8",
         "X-Triposo-Account": AuthorizationCenter.triposoAccount,
         "X-Triposo-Token":AuthorizationCenter.triposoToken]
    }
    
    
    func load(completion: @escaping (Result<Tags, Swift.Error>) -> Void) {
        locationManager.currentLocation(completion: { [weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let currentLocation):
                self.triposoLocationsLoader.loadLocations (currentLocation: currentLocation) { [weak self] result in
                    guard let self = self else {return}
                    switch result {
                    case .success(let locations):
                        guard let location = locations.results.first else {
                            completion(.failure(Self.Error.noNearbyLocations))
                            return
                        }
                        let request = DefaultHTTPClient.URLHTTPRequest (
                            relativePath: RemoteTagPathProvider.tags(cityLabelName: location.id),
                            body: nil,
                            headers: self.clientHeaders,
                            method: .get) 
                        
                        self.client.request(request: request) { [weak self]result in
                            guard let self = self else {return}
                            switch result {
                            case .success(let data):
                                do {
                                    let tags = try RemoteTagsMapper.decodeTagsData(data)
                                    completion(.success(tags))
                                } catch let error {
                                    completion(.failure(error))
                                }
                            case .failure(let error):
                                completion(.failure(error))
                            }
                        }
                    case.failure(let error):
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        } )
        
    }
    
}

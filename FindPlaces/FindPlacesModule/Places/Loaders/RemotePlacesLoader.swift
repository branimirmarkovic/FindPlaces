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


class RemotePlacesLoader: PlacesLoader {
    
    private let client: HTTPClient
    private let locationManager: LocationManager
    
    init(client: HTTPClient, locationManager: LocationManager) {
        self.client = client
        self.locationManager = locationManager
    }
    
    private var clientHeaders: [String : String] {
        ["Content-Type" : "application/json; charset=utf-8",
         "Accept": "application/json; charset=utf-8",
         "X-Triposo-Account": AuthorizationCenter.triposoAccount,
         "X-Triposo-Token":AuthorizationCenter.triposoToken]
    }

    private var searchDistance: Int {
        5000
    }

    func load(placeType: String, orderBy: OrderOptions, completion: @escaping (Result<Places, Error>) -> Void) {
        locationManager.currentLocation { [weak self] result in
            guard let self = self else {return}
            switch result {
            case.success(let location):
                let relativePath = RemotePlacesPathProvider.places(tagLabel: placeType, latitude: location.coordinate.latitude, longitude: location.coordinate.longitude, distance: self.searchDistance, orderBy: orderBy)
                let request = DefaultHTTPClient.URLHTTPRequest(
                    relativePath: relativePath,
                    body: nil,
                    headers: self.clientHeaders,
                    method: .get)

                self.client.request(request: request) { result in
                    switch result {
                    case .success(let data):
                        guard let data = data else {
                            return
                        }
                        do {
                            let places = try JSONDecoder().decode(Places.self, from: data)
                            completion(.success(places))
                        } catch let error {
                            completion(.failure(error))
                        }
                    case.failure(let error):
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

typealias PlacesTuple = (places: [Place], isThereMore: Bool)

fileprivate struct  RemoteRoot: Codable, Equatable {
    var results: [RemotePlace] 
    var more: Bool
    
    func toResult() -> PlacesTuple {
        (results.map{$0.toPlace()}, more)
    }
}

fileprivate struct RemotePlace: Codable, Equatable {
    var id: String
    var name: String
    var coordinates: Coordinates
    var score: Double
    var price_tier: Int?
    var intro: String
    var tags: [TagObject]
    var images: [PlaceImage]
    
    func toPlace() -> Place {
        Place(id: self.id,
              name: self.name,
              coordinates: self.coordinates,
              score: self.score,
              intro: self.intro,
              tags: self.tags, 
              images: self.images)
    }
}

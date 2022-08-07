//
//  RemoteLocationsLoader.swift
//  FindPlaces
//
//  Created by Branimir Markovic on 7.8.22..
//

import Foundation


fileprivate extension HTTPClient {
    var locationsHeaders: [String: String] {
            ["Content-Type" : "application/json; charset=utf-8",
             "Accept": "application/json; charset=utf-8",
             "X-Triposo-Account": AuthorizationCenter.triposoAccount,
             "X-Triposo-Token":AuthorizationCenter.triposoToken]
    }
}

final fileprivate class RemoteLocationsPathProvider {
    static func locations(latitude: Double, longitude: Double) -> String {
        "location.json?type=city&order_by=distance&annotate=distance:\(latitude),\(longitude)&distance=50000"
    }
}

final fileprivate class RemoteLocationsMapper {
    static func map( _ data: Data) throws -> [Location] {
        do {
            let remoteLocations = try JSONDecoder().decode(RemoteLocationsRoot.self, from: data)
            return remoteLocations.toLocations()
        } catch { throw error}
    }
}

class RemoteLocationsLoader: TriposoLocationsLoader{
    
    
    enum Error: Swift.Error {
        case clientError
        case noData
        case decodingError
    }
    
    private let client: HTTPClient
    
    init(client: HTTPClient) {
        self.client = client
    }
    
    
     func loadLocations(currentLocation: Coordinates, completion: @escaping (Result<[Location], Swift.Error>) -> Void) {
        let relativePath = RemoteLocationsPathProvider.locations(latitude: currentLocation.latitude, longitude: currentLocation.longitude)
        let request = DefaultHTTPClient.URLHTTPRequest(
            relativePath: relativePath,
            body: nil,
            headers: self.client.locationsHeaders,
            method: .get)

        self.client.request(request: request) { result in
            switch result {
            case .success(let data):
                guard let data = data else {
                    return completion(.failure(Error.noData))
                }
                do {
                    let locations = try RemoteLocationsMapper.map(data)
                    completion(.success(locations))
                } catch {
                    completion(.failure(Error.decodingError))
                }
            case.failure(_):
                completion(.failure(Error.clientError))
            }
        }
    }
}

fileprivate struct RemoteLocationsRoot: Decodable {
    var results: [RemoteLocation]
    
    func toLocations() -> [Location] {
        self.results.map {$0.toLocation()}
    }
    
}

fileprivate struct RemoteLocation: Decodable {
    var id: String
    var name: String
    
    func toLocation() -> Location {
        Location(id: id, name: name)
    }
}

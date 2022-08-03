//
//  TriposoService.swift
//  App
//
//  Created by Branimir Markovic on 18.12.21..
//

import Foundation
import CoreLocation


class TriposoService {
     let locationManager: LocationManager
     let client: HTTPClient
     let pathProvider: TriposoPathProvider

    init(client: HTTPClient, locationManager: LocationManager, pathProvider: TriposoPathProvider = TriposoPathProvider.main) {
        self.locationManager = locationManager
        self.client = client
        self.pathProvider = pathProvider
    }

    var clientHeaders: [String : String] {
        ["Content-Type" : "application/json; charset=utf-8",
         "Accept": "application/json; charset=utf-8",
         "X-Triposo-Account": AuthorizationCenter.triposoAccount,
         "X-Triposo-Token":AuthorizationCenter.triposoToken]
    }

}



extension TriposoService: PlacesLoader {

    var searchDistance: Int {
        5000
    }

    func load(placeType: String, orderBy: OrderOptions, completion: @escaping (Result<Places, Error>) -> Void) {
        locationManager.currentLocation { [weak self] result in
            guard let self = self else {return}
            switch result {
            case.success(let location):
                let relativePath = self.pathProvider.places(tagLabel: placeType, latitude: location.coordinate.latitude, longitude: location.coordinate.longitude, distance: self.searchDistance, orderBy: orderBy)
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

extension TriposoService: ImageLoader {
    func loadImage(url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else {
                completion(.failure(error!))
                return
            }
            completion(.success(data))
        }.resume()
    }
}

extension TriposoService {
    // MARK: - Private methods

    private func loadLocations(currentLocation: CLLocation, completion: @escaping (Result<Locations, Error>) -> Void) {
        let relativePath = pathProvider.locations(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude)
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
                    let locations = try JSONDecoder().decode(Locations.self, from: data)
                    completion(.success(locations))
                } catch let error {
                    completion(.failure(error))
                }
            case.failure(let error):
                completion(.failure(error))
            }
        }
    }


}

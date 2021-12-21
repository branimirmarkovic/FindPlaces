//
//  TriposoService.swift
//  App
//
//  Created by Branimir Markovic on 18.12.21..
//

import Foundation
import CoreLocation

enum OrderOptions: String{
    case distance = "distance"
    case score = "-score"
}

enum TriposoPaths {

    enum Base {
        static let path = "https://www.triposo.com/api/20211011/"
    }
    enum Relative {
        static func locations(location: CLLocationCoordinate2D) -> String {
            "location.json?type=city&order_by=distance&annotate=distance:\(location.latitude),\(location.longitude)&distance=50000"
        }
        static let tags = "tag.json?location_id=wv__Belgrade&order_by=-score&count=25&fields=name,poi_count,score,label&ancestor_label=eatingout"

        static func places(tagLabel: String, location: CLLocationCoordinate2D, distance: Int, orderBy: OrderOptions) -> String {
            "poi.json?tag_labels=\(tagLabel)&count=25&fields=id,name,score,price_tier,coordinates,intro,tags,images&order_by=\(orderBy.rawValue)&annotate=distance:\(location.latitude),\(location.longitude)&distance=<\(distance)"
        }
    }
}





class TriposoService {

    private var locationManager: LocationManager
    private var client: HTTPClient

    init(client: HTTPClient, locationManager: LocationManager) {
        self.locationManager = locationManager
        self.client = client
    }

    var clientHeaders: [String : String] {
        ["Content-Type" : "application/json; charset=utf-8",
         "Accept": "application/json; charset=utf-8",
         "X-Triposo-Account": "YDIYVMO2",
         "X-Triposo-Token":"7982cexehuvb40itknddvk3et5rlu2lx"]
    }

}


extension TriposoService: TagsLoader {


    func load(completion: @escaping (Result<Tags, Error>) -> Void) {
        let request = DefaultHTTPClient.URLHTTPRequest(
            relativePath: TriposoPaths.Relative.tags,
            body: nil,
            headers: clientHeaders ,
            method: .get)

        client.request(request: request) { result in
            switch result {
            case .success(let data):
                guard let data = data else {
                    return
                }
                do {
                    let tags = try JSONDecoder().decode(Tags.self, from: data)
                    completion(.success(tags))
                } catch let error {
                    completion(.failure(error))
                }
            case.failure(let error):
                completion(.failure(error))
            }
        }
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
                let relativePath = TriposoPaths.Relative.places(tagLabel: placeType, location: location.coordinate, distance: self.searchDistance, orderBy: orderBy)
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

    func userLocation(completion: @escaping (Result<CLLocation, Error>) -> Void) {
        locationManager.currentLocation { result in
            switch result {
            case.success(let location):
                completion(.success(location))
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

extension TriposoService: LocationsLoader {



    func loadLocations(currentLocation: CLLocation, completion: @escaping (Result<Locations, Error>) -> Void) {
        let relativePath = TriposoPaths.Relative.locations(location: currentLocation.coordinate)
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

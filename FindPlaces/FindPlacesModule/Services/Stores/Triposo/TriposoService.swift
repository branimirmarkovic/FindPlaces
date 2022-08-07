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




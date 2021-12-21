//
//  Location.swift
//  App
//
//  Created by Branimir Markovic on 21.12.21..
//

import Foundation
import CoreLocation

protocol LocationsLoader {
    func loadLocations(currentLocation: CLLocation, completion: @escaping (Result<Locations, Error>) -> Void)
}


struct Locations: Codable {
    var result: [Location]
}

struct Location: Codable {
    var id: String
    var name: String
}

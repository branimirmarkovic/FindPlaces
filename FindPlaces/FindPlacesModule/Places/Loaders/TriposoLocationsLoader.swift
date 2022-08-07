//
//  TriposoLocationsLoader.swift
//  FindPlaces
//
//  Created by Branimir Markovic on 7.8.22..
//

import Foundation


protocol TriposoLocationsLoader {
    func loadLocations(currentLocation: Coordinates, completion: @escaping (Result<[Location],Error>) -> Void)
}

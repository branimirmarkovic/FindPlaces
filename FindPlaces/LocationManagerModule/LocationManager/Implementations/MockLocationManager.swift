//
//  MockLocationManager.swift
//  FindPlaces
//
//  Created by Branimir Markovic on 19.4.22..
//

import Foundation
import CoreLocation

class MockLocationManager: LocationManager {
    
    func currentLocation(completion: @escaping (Result<CLLocation, Error>) -> Void) {
        let belgradeLocation = CLLocation(latitude: 44.78063113906512, longitude: 20.502867005228353)
        completion(.success(belgradeLocation))
    }
}

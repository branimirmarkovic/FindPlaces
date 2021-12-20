//
//  LocationManager.swift
//  App
//
//  Created by Branimir Markovic on 18.12.21..
//

import Foundation
import CoreLocation

protocol LocationManager {
    func currentLocation() -> CLLocationCoordinate2D
}


class DefaultLocationManager {

    let locationManager = CLLocationManager()


}

class MockLocationManager: LocationManager {
    func currentLocation() -> CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: 44.78063113906512, longitude: 20.502867005228353)
    }


}

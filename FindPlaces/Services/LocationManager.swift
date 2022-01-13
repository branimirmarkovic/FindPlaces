//
//  LocationManager.swift
//  App
//
//  Created by Branimir Markovic on 18.12.21..
//

import Foundation
import CoreLocation


protocol LocationPolicy {
    var validFor: TimeInterval {get set}
    func isLocationValid(_ savedLocation: SavedLocation) -> Bool
}

struct DefaultLocationPolicy: LocationPolicy {
    var validFor: TimeInterval = 180

    func isLocationValid(_ savedLocation: SavedLocation) -> Bool {

        let maxValidDate = savedLocation.timeStamp + validFor
        return maxValidDate >= Date()
    }
}

struct SavedLocation {
    let timeStamp: Date
    let location: CLLocation
}

protocol LocationManager {
    func currentLocation(completion: @escaping(Result<CLLocation,Error>) -> Void)
}


class DefaultLocationManager: NSObject, LocationManager {
    private var locationManager: CLLocationManager?
    private var locationCompletion: ((Result<CLLocation,Error>) -> Void)?

    private let locationPolicy: LocationPolicy

    private var lastLocation: SavedLocation?

    init(locationPolicy: LocationPolicy) {
        self.locationPolicy = locationPolicy
        self.locationManager = CLLocationManager()
        super.init()
    }

    func currentLocation(completion: @escaping (Result<CLLocation, Error>) -> Void) {
        if let lastLocation = lastLocation, locationPolicy.isLocationValid(lastLocation) {
            completion(.success(lastLocation.location))
        } else {
            locationCompletion = completion
            starMonitoring()

        }

    }

    private func starMonitoring() {
        locationManager?.delegate = self
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.startUpdatingLocation()
    }

    private func didComplete(result: Result<CLLocation,Error>) {
        locationManager?.stopUpdatingLocation()
        locationCompletion?(result)
        locationManager?.delegate = nil
    }


}

extension DefaultLocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {


        guard let location = locations.first else {
            didComplete(result: .failure(NSError(domain: "No locations", code: 0, userInfo: nil)))
            return}
        lastLocation = SavedLocation(timeStamp: Date(), location: location)
        didComplete(result: .success(location))

    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        didComplete(result: .failure(error))
    }

    
}

class MockLocationManager: LocationManager {
    var lastLocation: CLLocation?
    
    func currentLocation(completion: @escaping (Result<CLLocation, Error>) -> Void) {
        let location = CLLocation(latitude: 44.78063113906512, longitude: 20.502867005228353)
        completion(.success(location))
    }
}

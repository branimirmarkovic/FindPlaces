//
//  LocationManager.swift
//  App
//
//  Created by Branimir Markovic on 18.12.21..
//

import Foundation
import CoreLocation

typealias LocationClosure = ((Result<CLLocation,Error>)->Void)

protocol LocationManager {
    var lastLocation: CLLocation? {get}
    func currentLocation(completion: @escaping(Result<CLLocation,Error>) -> Void)
}


class DefaultLocationManager: NSObject, LocationManager {
    private var locationManager: CLLocationManager?
    private var locationCompletion: ((Result<CLLocation,Error>) -> Void)?

    var lastLocation: CLLocation?

    override init() {
        super.init()
    }

    func currentLocation(completion: @escaping (Result<CLLocation, Error>) -> Void) {
        locationCompletion = completion
        locationCompletion = completion
        starMonitoring()

    }

    private func starMonitoring() {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.startUpdatingLocation()
    }

    private func didComplete(result: Result<CLLocation,Error>) {
        locationManager?.stopUpdatingLocation()
        locationCompletion?(result)
        locationManager?.delegate = nil
        locationManager = nil
    }


}

extension DefaultLocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {


        guard let location = locations.first else {
            didComplete(result: .failure(NSError(domain: "No locations", code: 0, userInfo: nil)))
            return}
        lastLocation = location
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

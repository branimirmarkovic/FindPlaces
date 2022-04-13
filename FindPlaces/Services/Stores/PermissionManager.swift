//
//  PermissionManager.swift
//  FindPlaces
//
//  Created by Branimir Markovic on 13.4.22..
//

import Foundation
import CoreLocation

protocol PermissionManager {
    func askLocationPermission(completion: @escaping (Bool) -> Void)
    func isLocationPermitted() -> Bool
}

class DefaultPermissionManager: NSObject, PermissionManager {
    
    private let locationManager: CLLocationManager
    private var locationChangedHandler: ((Bool) -> Void)?
    
    init(locationManager: CLLocationManager) {
        self.locationManager = locationManager
    }
    func askLocationPermission(completion: @escaping (Bool) -> Void)  {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationChangedHandler = completion
    }
    
    func isLocationPermitted() -> Bool {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            return false
        case .restricted:
            return false
        case .denied:
            return false
        case .authorizedAlways:
            return true
        case .authorizedWhenInUse:
            return true
        @unknown default:
            return false
        }
    }
}

extension DefaultPermissionManager: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .notDetermined {
            manager.requestAlwaysAuthorization()
            return
        }
        
        switch manager.authorizationStatus {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
            break
        case .restricted:
            locationChangedHandler?(false)
            break
        case .denied:
            locationChangedHandler?(false)
            break
        case .authorizedAlways:
            locationChangedHandler?(true)
            break
        case .authorizedWhenInUse:
            locationChangedHandler?(true)
            break
        @unknown default:
            locationChangedHandler?(false)
            break
        }
        
        locationChangedHandler = nil

    }
}

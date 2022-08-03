//
//  PermissionManager.swift
//  FindPlaces
//
//  Created by Branimir Markovic on 13.4.22..
//

import Foundation
import CoreLocation
import UIKit

protocol PermissionManager {
    func askLocationPermission(completion: @escaping (LocationAuthorizationStatus) -> Void)
    func isLocationPermitted() -> LocationAuthorizationStatus
}

enum LocationAuthorizationStatus {
    case allowed
    case notDetermined
    case denied
    
   static func fromSystemStatus(_ systemStatus: CLAuthorizationStatus ) -> Self {
        var status: LocationAuthorizationStatus = .notDetermined
        switch systemStatus {
        case .notDetermined:
            status = .notDetermined
        case .restricted:
            status = .denied
        case .denied:
            status = .denied
        case .authorizedAlways:
            status = .allowed
        case .authorizedWhenInUse:
            status = .allowed
        case .authorized:
            status = .allowed
        @unknown default:
            fatalError()
        }
        return status
    }
}

class DefaultPermissionManager: NSObject, PermissionManager {
    
    private let locationManager: CLLocationManager
    private var locationChangedHandler: ((LocationAuthorizationStatus) -> Void)?
    
    init(locationManager: CLLocationManager) {
        self.locationManager = locationManager
    }
    
    func askLocationPermission(completion: @escaping (LocationAuthorizationStatus) -> Void)  {
        locationChangedHandler = completion
        requestLocationPermission()
        
    }
    
    func isLocationPermitted() -> LocationAuthorizationStatus {
        LocationAuthorizationStatus.fromSystemStatus(locationManager.authorizationStatus)
    }
    
    private func requestLocationPermission() {
        switch isLocationPermitted() {
        case .allowed:
            notify(for: .allowed)
        case .notDetermined:
            requestWhenInUse()
        case .denied:
            notify(for: .denied)
        }
    }
    
    private func notify(for status: LocationAuthorizationStatus) {
        locationChangedHandler?(status)
        locationChangedHandler = nil
    }
    
    private func requestWhenInUse() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
}

extension DefaultPermissionManager: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        guard manager.authorizationStatus != .notDetermined else {
            requestWhenInUse()
            return
        }
        
        switch manager.authorizationStatus {
            
        case .notDetermined:
            break
        case .restricted:
            notify(for: .denied)
        case .denied:
            notify(for: .denied)
        case .authorizedAlways:
            notify(for: .allowed)
        case .authorizedWhenInUse:
            notify(for: .allowed)
        @unknown default:
            fatalError()
        }

    }
}

//
//  GoogleMapView.swift
//  FindPlaces
//
//  Created by Branimir Markovic on 19.4.22..
//

import Foundation
import CoreLocation
import GoogleMaps


extension GMSMapView {
    convenience init(location: CLLocation, zoom: Float) {
        let camera = GMSCameraPosition(
            latitude: location.coordinate.latitude,
            longitude: location.coordinate.longitude,
            zoom: zoom)
        self.init(frame: .zero, camera: camera)
    }
}

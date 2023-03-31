//
//  MkMapView.swift
//  FindPlaces
//
//  Created by Branimir Markovic on 31.3.23..
//

import MapKit


extension MKMapView {
    
    func zoomTo(coordinates: Coordinates, viewSize: CGSize, animated: Bool = true) {
        let coordinate = CLLocationCoordinate2D(latitude: coordinates.latitude, longitude: coordinates.longitude)
        let placeMark = MKPlacemark(coordinate: coordinate)
        let mapItem = MKMapItem(placemark: placeMark)
        let camera = MKMapCamera(lookingAt: mapItem, forViewSize: viewSize, allowPitch: true)
        self.setCamera(camera, animated: animated)
    }
}

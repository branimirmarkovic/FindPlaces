//
//  PlaceModel.swift
//  App
//
//  Created by Branimir Markovic on 18.12.21..
//

import Foundation

struct PointOfInterest: Equatable {
    var name: String
    var coordinates: Coordinates
    var phoneNumber: String?
    var poiCategory: PointOfInterestCategory?
    var adress: String?
}


struct Coordinates: Equatable {
    var latitude: Double
    var longitude: Double
}




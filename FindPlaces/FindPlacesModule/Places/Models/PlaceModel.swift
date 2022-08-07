//
//  PlaceModel.swift
//  App
//
//  Created by Branimir Markovic on 18.12.21..
//

import Foundation

struct PointOfInterest: Equatable {
    var id: String
    var name: String
    var coordinates: Coordinates
    var score: Double
    var priceTier: Int?
    var intro: String
    var tags: [Tag]
    var imageURLs: [PlaceImageURL]
}


struct Coordinates: Equatable {
    var latitude: Double
    var longitude: Double
}

struct PlaceImageURL:  Equatable {
    var thumbnailURL: String?
    var mediumURL: String?
    var originalURL: String?
}




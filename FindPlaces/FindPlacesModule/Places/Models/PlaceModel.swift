//
//  PlaceModel.swift
//  App
//
//  Created by Branimir Markovic on 18.12.21..
//

import Foundation


struct Places: Codable, Equatable, TimeValidable {
    var timeStamp: Date?

    var results: [Place] {
        didSet {
            timeStamp = Date()
        }
    }
    var more: Bool
}

struct Place: Codable, Equatable {
    var id: String
    var name: String
    var coordinates: Coordinates
    var score: Double
    var price_tier: Int?
    var intro: String
    var tags: [TagObject]
    var images: [PlaceImage]

}

struct TagObject: Codable, Equatable {
    var tag: Tag
    
}

struct Coordinates: Codable, Equatable {
    var latitude: Double
    var longitude: Double
}

struct PlaceImage: Codable, Equatable {
    var sizes: ImageSizes
}

struct ImageSizes: Codable, Equatable {
    var thumbnail: ImageSize
    var medium: ImageSize
    var original: ImageSize
}

struct ImageSize: Codable, Equatable {
    var url: String
}



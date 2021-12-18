//
//  PlaceModel.swift
//  App
//
//  Created by Branimir Markovic on 18.12.21..
//

import Foundation


struct Place: Codable {
    var id: String
    var name: String
    var coordinates: Coordinates
    var score: Double
    var price_tier: Int
    var distance: Int

}

struct Coordinates: Codable {
    var latitude: Double
    var longitude: Double
}

struct Places: Codable {
    var results: [Place]
    var more: Bool
}

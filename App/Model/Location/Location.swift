//
//  Location.swift
//  App
//
//  Created by Branimir Markovic on 21.12.21..
//

import Foundation
import CoreLocation


struct Locations: Codable {
    var results: [Location]
}

struct Location: Codable {
    var id: String
    var name: String
}

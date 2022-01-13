//
//  Tag.swift
//  App
//
//  Created by Branimir Markovic on 18.12.21..
//

import Foundation

struct Tag: Codable, Equatable {
    var name: String
    var label: String
    var score: Double
    var poi_count: Int
}

struct Tags: Codable, Equatable {
    var results: [Tag]
    var more: Bool
}
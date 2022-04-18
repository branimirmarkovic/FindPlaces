//
//  LocationPolicy.swift
//  FindPlaces
//
//  Created by Branimir Markovic on 19.4.22..
//

import Foundation

protocol LocationPolicy {
    var validFor: TimeInterval {get set}
    func isLocationValid(_ savedLocation: SavedLocation) -> Bool
}

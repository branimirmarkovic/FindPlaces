//
//  AlwaysValidLocationPolicy.swift
//  FindPlaces
//
//  Created by Branimir Markovic on 19.4.22..
//

import Foundation


struct AlwaysValidLocationPolicy: LocationPolicy {
    var validFor: TimeInterval = 0
    
    func isLocationValid(_ savedLocation: SavedLocation) -> Bool {
        true
    }
}

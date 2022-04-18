//
//  DefaultLocationPolicy.swift
//  FindPlaces
//
//  Created by Branimir Markovic on 19.4.22..
//

import Foundation

struct DefaultLocationPolicy: LocationPolicy {
    var validFor: TimeInterval = 180

    func isLocationValid(_ savedLocation: SavedLocation) -> Bool {

        let maxValidDate = savedLocation.timeStamp + validFor
        return maxValidDate >= Date()
    }
}

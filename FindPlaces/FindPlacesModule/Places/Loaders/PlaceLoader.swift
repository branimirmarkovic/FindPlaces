//
//  PlaceLoader.swift
//  App
//
//  Created by Branimir Markovic on 18.12.21..
//

import Foundation
import CoreLocation


typealias PointsOfInterestTuple = (places: [PointOfInterest], isThereMore: Bool)

protocol PointsOfInterestLoader {
    func load(placeType: String,orderBy: OrderOptions, completion: @escaping(Result<PointsOfInterestTuple,Error>) -> Void)
}

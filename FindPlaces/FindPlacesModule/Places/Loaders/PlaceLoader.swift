//
//  PlaceLoader.swift
//  App
//
//  Created by Branimir Markovic on 18.12.21..
//

import Foundation
import CoreLocation


//protocol PlaceLoader {
//    func load(completion: @escaping (Result<PointOfInterest,Error>) -> Void)
//}
typealias PointsOfInterestTuple = (places: [PointOfInterest], isThereMore: Bool)

protocol PointsOfInterestLoader {
    func load(placeType: String,orderBy: OrderOptions, completion: @escaping(Result<PointsOfInterestTuple,Error>) -> Void)
}

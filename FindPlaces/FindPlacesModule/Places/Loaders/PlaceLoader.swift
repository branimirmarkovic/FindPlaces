//
//  PlaceLoader.swift
//  App
//
//  Created by Branimir Markovic on 18.12.21..
//

import Foundation


typealias PointsOfInterestTuple = (places: [PointOfInterest], isThereMore: Bool)

enum OrderOptions {
    case distance
    case score 
}

protocol PointsOfInterestLoader {
    func load(placeType: String,orderBy: OrderOptions, completion: @escaping(Result<PointsOfInterestTuple,Error>) -> Void)
}

class MockPointsOfInterestLoader: PointsOfInterestLoader {
    func load(placeType: String, orderBy: OrderOptions, completion: @escaping (Result<PointsOfInterestTuple, Error>) -> Void) {
        completion(.failure(NSError()))
    }
    
    
}
import MapKit
class MKMapPOILoader: PointsOfInterestLoader {
    func load(placeType: String, orderBy: OrderOptions, completion: @escaping (Result<PointsOfInterestTuple, Error>) -> Void) {
        
    }
    
    
}

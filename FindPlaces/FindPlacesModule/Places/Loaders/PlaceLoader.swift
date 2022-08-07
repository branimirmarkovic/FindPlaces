//
//  PlaceLoader.swift
//  App
//
//  Created by Branimir Markovic on 18.12.21..
//

import Foundation
import CoreLocation


protocol PlaceLoader {
    func load(completion: @escaping (Result<Place,Error>) -> Void)
}
typealias PlacesTuple = (places: [Place], isThereMore: Bool)

protocol PlacesLoader {
    func load(placeType: String,orderBy: OrderOptions, completion: @escaping(Result<PlacesTuple,Error>) -> Void)
}

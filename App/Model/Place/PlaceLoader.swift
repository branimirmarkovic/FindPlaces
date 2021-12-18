//
//  PlaceLoader.swift
//  App
//
//  Created by Branimir Markovic on 18.12.21..
//

import Foundation


protocol PlaceLoader {
    func load(completion: @escaping (Result<Place,Error>) -> Void)
}

protocol PlacesLoader {
    func load(placeType: String, completion: @escaping(Result<[Place],Error>) -> Void) 
}

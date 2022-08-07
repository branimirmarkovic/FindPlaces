//
//  AlwaysFailingStore.swift
//  App
//
//  Created by Branimir Markovic on 18.12.21..
//

import Foundation
import CoreLocation


class AlwaysFailingStore: MainStore {
    func load(placeType: String, orderBy: OrderOptions, completion: @escaping (Result<PlacesTuple, Error>) -> Void) {
        completion(.failure(NSError()))
    }
    
    func load(completion: @escaping (Result<TagsTuple, Error>) -> Void) {
        completion(.failure(NSError()))
    }
    
    func loadImage(url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
        completion(.failure(NSError()))
    }
}

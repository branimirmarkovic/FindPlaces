//
//  AlwaysFailingStore.swift
//  App
//
//  Created by Branimir Markovic on 18.12.21..
//

import Foundation
import CoreLocation


class AlwaysFailingStore: MainStore {
    func loadImage(url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
        completion(.failure(NSError()))
    }

    func userLocation(completion: @escaping (Result<CLLocation, Error>) -> Void) {
        completion(.failure(NSError()))
    }

    func load(placeType: String,orderBy: OrderOptions, completion: @escaping (Result<Places, Error>) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            completion(.failure(NSError()))
        }
    }

    func load(completion: @escaping (Result<Tags, Error>) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            completion(.failure(NSError()))
        }
    }


}

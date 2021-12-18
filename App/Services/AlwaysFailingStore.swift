//
//  AlwaysFailingStore.swift
//  App
//
//  Created by Branimir Markovic on 18.12.21..
//

import Foundation


class AlwaysFailingStore: MainStore {
    func load(placeType: String, completion: @escaping (Result<[Place], Error>) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            completion(.failure(NSError(domain: "Empty Error", code: 0, userInfo: nil)))
        }
    }

    func load(completion: @escaping (Result<Tags, Error>) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            completion(.failure(NSError(domain: "Empty Error", code: 0, userInfo: nil)))
        }
    }


}

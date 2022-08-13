//
//  LocalDataManager.swift
//  FindPlaces
//
//  Created by Branimir Markovic on 13.8.22..
//

import Foundation

protocol LocalDataManager {
    func read(from url: URL, completion: @escaping (Result<Data,Error>) -> Void)
    func write(data: Data, to url: URL, completion: @escaping (Result<Void,Error>) -> Void)
    func delete(at url: URL, completion: @escaping (Result<Void,Error>) -> Void)
}

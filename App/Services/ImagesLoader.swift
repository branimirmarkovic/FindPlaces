//
//  ImagesLoader.swift
//  App
//
//  Created by Branimir Markovic on 21.12.21..
//

import Foundation
import UIKit


protocol ImageLoader {
    func loadImage(url: URL, completion: @escaping(Result<Data, Error>) -> Void)
}

class FailingImageLoader: ImageLoader {

    func loadImage(url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
        completion(.failure(NSError(domain: "Error", code: 0, userInfo: nil)))
    }
}

class MockImageLoader: ImageLoader {
    func loadImage(url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
        let image = UIImage(systemName: "person.fill")!.pngData()
        completion(.success(image!))
    }
}

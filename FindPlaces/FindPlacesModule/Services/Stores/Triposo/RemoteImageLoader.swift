//
//  RemoteImageLoader.swift
//  App
//
//  Created by Branimir Markovic on 18.12.21..
//

import Foundation
import CoreLocation

class RemoteImageLoader: ImageLoader {
    
    enum Error: Swift.Error {
        case clientError
        case noData
    }
    
    private let client: HTTPClient
    
    init(client: HTTPClient) {
        self.client = client
    }
    
    func loadImage(url: URL, completion: @escaping (Result<Data, Swift.Error>) -> Void) {
        client.download(with: url.absoluteString) { result in
            switch result {
            case .success(let data):
                guard let data = data else {return completion(.failure(Error.noData))}
                completion(.success(data))
            case .failure(_):
                completion(.failure(Error.clientError))
            }
        }
    }
    
    
}




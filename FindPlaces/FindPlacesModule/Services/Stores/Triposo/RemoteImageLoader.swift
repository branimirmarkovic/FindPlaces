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
    
    func loadImage(url: URL, completion: @escaping (Result<ImageData, Swift.Error>) -> Void) {
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

final private class LocalImagesPathProvider {
    static func path(for url: URL) -> String {
        let filename = abs(url.path.hashValue)
        return "/ImagesDirectory/\(filename).json"
    }
}

final private class LocalImagesMapper {
    static func map(data: Data) throws -> LocalImage {
        let remoteImage = try JSONDecoder().decode(LocalImage.self, from: data)
        return remoteImage
    }
}

final private class LocalImageEncoder {
    static func encode(_ localImage: LocalImage) throws -> Data {
        return try JSONEncoder().encode(localImage)
    }
}

class RemoteImageLoaderWithCaching: ImageLoader {
    
    private let remoteImageLoader: RemoteImageLoader
    private let localDataManager: LocalDataManager
    
    init(remoteImageLoader: RemoteImageLoader, localDataManager: LocalDataManager) {
        self.remoteImageLoader = remoteImageLoader
        self.localDataManager = localDataManager
    }
    
    func loadImage(url: URL, completion: @escaping (Result<ImageData, Error>) -> Void) {
        remoteImageLoader.loadImage(url: url) { [weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let data):
                let localImage = LocalImage(timeStamp: Date(), data: data)
                if let imageData = try? LocalImageEncoder.encode(localImage){
                    self.localDataManager.write(data: imageData, to: LocalImagesPathProvider.path(for: url), completion: {_ in })
                }
                completion(.success(data))
            case .failure(let failure):
                completion(.failure(failure))
            }
        }
    }
}




class RemoteImageLoaderWithLocalDataReadingFirst: ImageLoader {
    
    
    
    private let remoteImageLoaderWithCaching: RemoteImageLoaderWithCaching
    private let localDataManager: LocalDataManager
    private let cachePolicy: DataCachePolicy
    
    internal init(remoteImageLoaderWithCaching: RemoteImageLoaderWithCaching, localDataManager: LocalDataManager, cachePolicy: DataCachePolicy) {
        self.remoteImageLoaderWithCaching = remoteImageLoaderWithCaching
        self.localDataManager = localDataManager
        self.cachePolicy = cachePolicy
    }
    
    func loadImage(url: URL, completion: @escaping (Result<ImageData, Error>) -> Void) {
        let path = LocalImagesPathProvider.path(for: url)
        localDataManager.read(from: path) { result in
            switch result {
            case .success(let data):
                do {
                    let localImage = try LocalImagesMapper.map(data: data)
                    if self.cachePolicy.isDataValid(of: localImage) {
                        completion(.success(localImage.data))
                    } else {
                       self.remoteImageLoaderWithCaching.loadImage(url: url, completion: completion)
                    }
                } catch {
                    self.remoteImageLoaderWithCaching.loadImage(url: url, completion: completion)
                }
            case .failure(_):
                self.remoteImageLoaderWithCaching.loadImage(url: url, completion: completion)
            }
        }
    }
}

struct LocalImage: Codable, TimeValidable {
    var timeStamp: Date
    var data: ImageData
}




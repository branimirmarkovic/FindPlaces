//
//  DefaultHTTPClient.swift
//  App
//
//  Created by Branimir Markovic on 17.12.21..
//

import Foundation


enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}


class DefaultHTTPClient: HTTPClient {
    
    

    struct URLHTTPRequest: HTTPRequest {
        var relativePath: String
        var body: Data?
        var headers: [String : String]
        var method: HTTPMethod
    }

    struct URLHTTPClientTask: HTTPClientTask {
        let dataTask: URLSessionDataTask

        func cancel() {
            dataTask.cancel()
        }
    }

    enum HTTPError: Error {
        case badHTTPRequest
        case unsupportedResponse
        case badStatusCode(Int)
        case unknown(Error?)
    }

    internal var basePath: String
    private var session: URLSession

    private var validStatusCodes = 200..<300

    init(basePath: String, session: URLSession = URLSession.shared) {
        self.session = session
        self.basePath = basePath
    }
    
    @discardableResult  func download(with url: String, completion: @escaping (Result<Data?, Error>) -> Void) -> HTTPClientTask? {
        guard let url = URL(string: url) else {
            completion(.failure(HTTPError.badHTTPRequest))
            return nil
        }
        
        let dataTask = session.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else { return completion(.failure(HTTPError.unknown(nil))) }
            if let error = error {
                completion(.failure(HTTPError.unknown(error)))
            } else if let response = response as? HTTPURLResponse {

                if self.validStatusCodes.contains(response.statusCode) {
                    completion(.success(data))
                } else {
                    completion(.failure(HTTPError.badStatusCode(response.statusCode)))
                }
            } else {
                completion(.failure(HTTPError.unsupportedResponse))
            }
        }
        dataTask.resume()
        return URLHTTPClientTask(dataTask: dataTask)
    }

    @discardableResult  func request(request: HTTPRequest, completion: @escaping (Result<Data?, Error>) -> Void) -> HTTPClientTask? {
        guard let request = request.toURLRequest(basePath: basePath) else {
            completion(.failure(HTTPError.badHTTPRequest))
            return nil
        }
        let dataTask = session.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self else { return completion(.failure(HTTPError.unknown(nil))) }
            if let error = error {
                completion(.failure(HTTPError.unknown(error)))
            } else if let response = response as? HTTPURLResponse {

                if self.validStatusCodes.contains(response.statusCode) {
                    completion(.success(data))
                } else {
                    completion(.failure(HTTPError.badStatusCode(response.statusCode)))
                }
            } else {
                completion(.failure(HTTPError.unsupportedResponse))
            }
        }
        dataTask.resume()
        return URLHTTPClientTask(dataTask: dataTask)
    }


}

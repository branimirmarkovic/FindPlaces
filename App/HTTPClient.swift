//
//  HTTPClient.swift
//  App
//
//  Created by Branimir Markovic on 17.12.21..
//

import Foundation

protocol HTTPClient {
    var basePath: String {get set}
   @discardableResult func request(request: HTTPRequest, completion: @escaping (Result<Data?,Error>) -> Void) -> HTTPClientTask
}

protocol HTTPClientTask {
    func cancel()
}

protocol HTTPRequest {
    var relativePath: String {get set}
    var body: Data? {get set}
    var headers: [String: String] {get set}
    var method: HTTPMethod {get set}
}


enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case patch = "PATCH"
    case head = "HEAD"
    case connect = "CONNECT"
    case options = "OPTIONS"
    case trace = "TRACE"
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
        case unsupportedResponse
        case badStatusCode(Int)
        case unknown(Error?)
    }

    var basePath: String
    var session: URLSession

    private var validStatusCodes = 200..<300

    init(basePath: String, session: URLSession) {
        self.session = session
        self.basePath = basePath
    }

    func request(request: HTTPRequest, completion: @escaping (Result<Data?, Error>) -> Void) -> HTTPClientTask {
        let dataTask = session.dataTask(with: request.toURLRequest()) { [weak self] data, response, error in
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

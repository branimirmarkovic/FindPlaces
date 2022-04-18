//
//  HTTPClient.swift
//  FindPlaces
//
//  Created by Branimir Markovic on 19.4.22..
//

import Foundation

protocol HTTPClient {
    var basePath: String {get set}
   @discardableResult func request(request: HTTPRequest, completion: @escaping (Result<Data?,Error>) -> Void) -> HTTPClientTask?
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

extension HTTPRequest {
    func toURLRequest(basePath:String) -> URLRequest? {
        let string = basePath + relativePath
        let encoded = string.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)!

        
        guard let url = URL(string: encoded) else {return nil}

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        self.headers.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }
        request.httpBody = body
        return request
    }
}

//
//  TriposoService.swift
//  App
//
//  Created by Branimir Markovic on 18.12.21..
//

import Foundation

enum TriposoPaths {
    enum Base {
        static let path = "https://www.triposo.com/api/20211011/"
    }
    enum Relative {
        static let tags = "tag.json?location_id=wv__Belgrade&order_by=-score&count=25&fields=name,poi_count,score,label&ancestor_label=cuisine"
    }
}


class TriposoService {

    private var client: HTTPClient

    init(client: HTTPClient) {
        self.client = client
    }

}

extension TriposoService: TagsLoader {
    func load(completion: @escaping (Result<Tags, Error>) -> Void) {
        let request = DefaultHTTPClient.URLHTTPRequest(
            relativePath: TriposoPaths.Relative.tags,
            body: nil,
            headers: [
                "content" : "json",
                "auth": "code"],
            method: .get)

        client.request(request: request) { result in
            switch result {
            case .success(let data):
                guard let data = data else {
                    return
                }
                do {
                    let tags = try JSONDecoder().decode(Tags.self, from: data)
                    completion(.success(tags))
                } catch let error {
                    completion(.failure(error))
                }
            case.failure(let error):
                completion(.failure(error))
            }
        }
    }


}

//
//  TagLoader.swift
//  App
//
//  Created by Branimir Markovic on 18.12.21..
//

import Foundation

typealias TagsTuple = (tags: [Tag], more: Bool)

protocol TagsLoader {
    func load(completion: @escaping(Result<TagsTuple,Error>) -> Void)
}

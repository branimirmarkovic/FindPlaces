//
//  TagLoader.swift
//  App
//
//  Created by Branimir Markovic on 18.12.21..
//

import Foundation

protocol TagsLoader {
    func load(completion: @escaping(Result<Tags,Error>) -> Void)
}

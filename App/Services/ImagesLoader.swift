//
//  ImagesLoader.swift
//  App
//
//  Created by Branimir Markovic on 21.12.21..
//

import Foundation


protocol ImageLoader {
    func loadImage(url: URL, completion: @escaping(Result<Data, Error>) -> Void)
}

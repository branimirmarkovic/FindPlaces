//
//  NSError.swift
//  FindPlaces
//
//  Created by Branimir Markovic on 7.8.22..
//

import Foundation

extension NSError {
    public convenience init (_ message: String = "") {
        self.init(domain: message, code: 0)
    }
}

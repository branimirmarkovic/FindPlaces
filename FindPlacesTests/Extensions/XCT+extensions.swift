//
//  XCT+extensions.swift
//  FindPlacesTests
//
//  Created by Branimir Markovic on 6.4.23..
//

import XCTest


extension XCTestCase {
    open func wait( _ expectation: XCTestExpectation, timeout: TimeInterval = 1) {
        wait(for: [expectation], timeout: timeout)
    }
    
    open func expectation() -> XCTestExpectation {
        expectation(description: "")
    }
}

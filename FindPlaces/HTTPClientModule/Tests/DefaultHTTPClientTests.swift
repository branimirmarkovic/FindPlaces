//
//  DefaultHTTPClientTests.swift
//  AppTests
//
//  Created by Branimir Markovic on 12.1.22..
//

import XCTest
@testable import FindPlaces


class DefaultHTTPClientTests: XCTestCase {

    var performanceLimit: TimeInterval {
        3
    }

    func test_invalidHTTPRequestProvided_makeRequest_clientMakesRequest_fail() {
        let sut = makeSUT(basePath: invalidBasePath)
        let expectation = expectation(description: "Expecting response from client")

        sut.request(request: emptyHTTPRequest) { result in
            switch result {
            case .failure(let error):
                if let error = error as? DefaultHTTPClient.HTTPError, case DefaultHTTPClient.HTTPError.badHTTPRequest = error {} else {
                    XCTFail("Invalid error")
                }
            case .success(_):
                XCTFail("Client should not make successful request")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: performanceLimit)
    }

    func test_validHTTPRequestProvided_makeRequest_clientMakesRequest_fail() {
        let sut = makeSUT(basePath: productionBasePath)
        let expectation = expectation(description: "Expecting response from client")

        sut.request(request: validHTTPRequest) { result in
            switch result {
            case.success(_):
                ()
            case.failure(let error):
                XCTFail("Expected client to succeed, got error: \(error)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: performanceLimit)
    }


    func makeSUT(basePath: String) -> DefaultHTTPClient {
        DefaultHTTPClient(basePath: basePath, session: URLSession.shared)
    }

    var productionBasePath: String {
        "https://www.triposo.com/api/20211011/"
    }

    var invalidBasePath: String {
        ""
    }

    var emptyHTTPRequest: HTTPRequest {
        DefaultHTTPClient.URLHTTPRequest(
            relativePath: "",
            body: nil,
            headers: [:],
            method: .get)
    }

    var validHTTPRequest: HTTPRequest {
        DefaultHTTPClient.URLHTTPRequest(
            relativePath:"tag.json?location_id=wv__Belgrade&order_by=-score&count=25&fields=name,poi_count,score,label&ancestor_label=eatingout",
            body: nil,
            headers: ["Content-Type" : "application/json; charset=utf-8",
                      "Accept": "application/json; charset=utf-8",
                      "X-Triposo-Account": "YDIYVMO2",
                      "X-Triposo-Token":"7982cexehuvb40itknddvk3et5rlu2lx"],
            method: .get)
    }
}

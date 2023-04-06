//
//  DefaultHTTPClientTests.swift
//  AppTests
//
//  Created by Branimir Markovic on 12.1.22..
//

import XCTest
@testable import FindPlaces


class DefaultHTTPClientTests: XCTestCase {
    var httpClient: DefaultHTTPClient!
    var urlSession: URLSession!
    let validURL = "https://api.example.com"

    override func setUpWithError() throws {
        try super.setUpWithError()
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        urlSession = URLSession(configuration: configuration)
        httpClient = DefaultHTTPClient(basePath: validURL, session: urlSession)
        MockURLProtocol.mockResponse = (Data(), HTTPURLResponse(url: URL(string: validURL)!, statusCode: 200, httpVersion: nil, headerFields: nil), nil)
        httpClient = DefaultHTTPClient(basePath: validURL, session: urlSession)
    }

    override func tearDownWithError() throws {
        httpClient = nil
        urlSession = nil
        MockURLProtocol.mockResponse = nil
        try super.tearDownWithError()
    }

    func testRequestSuccess() {
        let expectation = self.expectation(description: "Request completion")
        MockURLProtocol.mockResponse = (Data(), HTTPURLResponse(url: URL(string: validURL)!, statusCode: 200, httpVersion: nil, headerFields: nil), nil)

        let request = DefaultHTTPClient.URLHTTPRequest(relativePath: "/test", body: nil, headers: [:], method: .get)

        httpClient.request(request: request) { result in
            switch result {
            case .success:
                XCTAssertTrue(true)
            case .failure(let error):
                XCTFail("Request should have succeeded, but failed with error: \(error.localizedDescription)")
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1, handler: nil)
    }

    func testRequestFailure() {
        let expectation = self.expectation(description: "Request completion")
        MockURLProtocol.mockResponse = (nil, nil, NSError(domain: "", code: 0, userInfo: nil))

        let request = DefaultHTTPClient.URLHTTPRequest(relativePath: "/test", body: nil, headers: [:], method: .get)

        httpClient.request(request: request) { result in
            switch result {
            case .success:
                XCTFail("Request should have failed")
            case .failure:
                XCTAssertTrue(true)
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1, handler: nil)
    }

    func testDownloadSuccess() {
        let expectation = self.expectation(description: "Download completion")
        MockURLProtocol.mockResponse = (Data(), HTTPURLResponse(url: URL(string: validURL)!, statusCode: 200, httpVersion: nil, headerFields: nil), nil)

        httpClient.download(with: validURL) { result in
            switch result {
            case .success:
                XCTAssertTrue(true)
            case .failure(let error):
                XCTFail("Download should have succeeded, but failed with error: \(error.localizedDescription)")
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1, handler: nil)
    }

    func testDownloadFailure() {
        let expectation = self.expectation(description: "Download completion")
        MockURLProtocol.mockResponse = (nil, nil, NSError(domain: "", code: 0, userInfo: nil))

        httpClient.download(with: validURL) { result in
            switch result {
            case .success:
                XCTFail("Download should have failed")
            case .failure:
                XCTAssertTrue(true)
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1, handler: nil)
    }
}




class MockURLProtocol: URLProtocol {
    static var mockResponse: (Data?, URLResponse?, Error?)?

    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override func startLoading() {
        if let (data, response, error) = MockURLProtocol.mockResponse {
            if let response = response {
                self.client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            }
            if let data = data {
                self.client?.urlProtocol(self, didLoad: data)
            }
            if let error = error {
                self.client?.urlProtocol(self, didFailWithError: error)
            }
        }
        self.client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() {}
}



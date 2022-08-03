//
//  TriposoServiceTests.swift
//  AppTests
//
//  Created by Branimir Markovic on 12.1.22..
//

import XCTest
import CoreLocation
@testable import FindPlaces

class TriposoServiceTests: XCTestCase {


    func test_loadsTags_AlwaysSuccessfulClient_Success() {
        let expectedTags = dummyTags
        let returnedDataFromClient = dummyTagsData
        let sut = makeSut(client: Client_AlwaysValid(returnData: returnedDataFromClient), locationManager: LocationManager_Valid())
        let expectation = expectation(description: "Client finished")

        sut.load { result in
            switch result {
            case .success(let tags):
                if tags != expectedTags  {
                    XCTFail("Expected exact decoded tags, got different tags")
                }
            case .failure(let error):
                XCTFail("Expected success, got error: \(error)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: PerformanceCenter.clientRequestsTimeLimit)
    }

    func test_loadTags_FailingClient_Fails() {
        let sut = makeSut(client: Client_AlwaysFailing(), locationManager: LocationManager_Valid())

        let expectation = expectation(description: "Client finished")

        sut.load { result in
            switch result {
            case.success(_):
                XCTFail("Expected failure, got success")
            case .failure(_):
                ()
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: PerformanceCenter.clientRequestsTimeLimit)

    }

    func test_loadPlaces_validClient_validLocationManager_success() {
        let placesData = dummyPlacesData
        let expectedPlaces = dummyPlaces
        let sut = makeSut(client: Client_AlwaysValid(returnData: placesData), locationManager: LocationManager_Valid())

        let expectation = expectation(description: "Client finished")

        sut.load(placeType: "", orderBy: .distance) { result in
            switch result {
            case .success(let places):
                if places != expectedPlaces {
                    XCTFail("Loader returned invalid Places object")
                }
            case .failure(let error):
                XCTFail("Expected success, got error: \(error)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: PerformanceCenter.clientRequestsTimeLimit)

    }

    func test_loadPlaces_validClient_invalidLocationManager_fail() {
        let sut = makeSut(client: Client_AlwaysValid(), locationManager: LocationManager_Invalid())
        let expectation = expectation(description: "Client finished")

        sut.load(placeType: "", orderBy: .distance) { result in
            switch result {
            case .success(_):
                    XCTFail("Expected fail, got success")
            case .failure(_):
                ()
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: PerformanceCenter.clientRequestsTimeLimit)

    }

    func test_loadPlaces_invalidClient_validLocationManager_fail() {
        let sut = makeSut(client: Client_AlwaysFailing(), locationManager: LocationManager_Valid())
        let expectation = expectation(description: "Client finished")

        sut.load(placeType: "", orderBy: .distance) { result in
            switch result {
            case .success(_):
                    XCTFail("Expected fail, got success")
            case .failure(_):
                ()
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: PerformanceCenter.clientRequestsTimeLimit)

    }


   private  func makeSut(client: HTTPClient, locationManager: LocationManager) -> TriposoService {
        TriposoService(client: client, locationManager: locationManager)
    }

    private var client_production: HTTPClient {
        DefaultHTTPClient(basePath: TriposoPaths.Base.path)
    }

    private class Client_AlwaysFailing: HTTPClient {
        var basePath: String

        init() {
            self.basePath = ""
        }

        func request(request: HTTPRequest, completion: @escaping (Result<Data?, Error>) -> Void) -> HTTPClientTask? {
            completion(.failure(NSError(domain: "", code: 0, userInfo: nil)))
            return nil
        }
    }

    private class Client_AlwaysValid: HTTPClient {
        var basePath: String
        var returnData: Data?

        init(returnData: Data? = nil) {
            self.basePath = TriposoPaths.Base.path
            self.returnData = returnData
        }

        func request(request: HTTPRequest, completion: @escaping (Result<Data?, Error>) -> Void) -> HTTPClientTask? {
            completion(.success(returnData))
            return nil
        }


    }

    private class LocationManager_Valid: LocationManager {
        func currentLocation(completion: @escaping (Result<CLLocation, Error>) -> Void) {
            let location = CLLocation(latitude: 44.78063113906512, longitude: 20.502867005228353)
            completion(.success(location))
        }
    }

    private class LocationManager_Invalid: LocationManager {
        func currentLocation(completion: @escaping (Result<CLLocation, Error>) -> Void) {
            completion(.failure(NSError(domain: "", code: 0, userInfo: nil)))
        }
    }

   private  var dummyTagsData: Data {
         try! JSONEncoder().encode(dummyTags)
    }

   private  var dummyTags: Tags {
        Tags(results: []
             , more: false)
    }

    private var dummyPlaces: Places {
        Places(results: [], more: false)
    }

    private var dummyPlacesData: Data {
        try! JSONEncoder().encode(dummyPlaces)
    }

}

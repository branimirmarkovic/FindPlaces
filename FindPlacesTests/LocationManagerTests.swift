//
//  LocationManagerTests.swift
//  AppTests
//
//  Created by Branimir Markovic on 25.12.21..
//

import XCTest
@testable import App


class LocationManagerTests: XCTestCase {


    func test_returnLocation_invalidLastLocation_loadsLocationFromCoreLocationServices_success() {
        let sut = makeSUT(locationPolicy: InvalidLocationPolicy())

        let locationLoad = expectation(description: "Location")

        sut.currentLocation { result in
            switch result {
            case .success(_):
                ()
            case .failure(let error):
                XCTFail("Expected location, got error: \(error.localizedDescription)")
            }
            locationLoad.fulfill()
        }
        wait(for: [locationLoad], timeout: 3)

    }

    func test_returnLocation_validLastLocation_loadsFromSavedLocation_success() {
        let sut = makeSUT(locationPolicy: ValidLocationPolicy())

        let firstLocationLoad = expectation(description: "First location load")
        let secondLocationLoad = expectation(description: "Loading last saved location")
        sut.currentLocation { _ in
            firstLocationLoad.fulfill()
            sut.currentLocation { result in
                switch result {
                case .success(_):
                    ()
                case .failure(let error):
                    XCTFail("Expected location, got error: \(error.localizedDescription)")
                }
                secondLocationLoad.fulfill()
            }
        }
        wait(for: [firstLocationLoad,secondLocationLoad], timeout: 3)
    }


    private func makeSUT(locationPolicy: LocationPolicy) -> DefaultLocationManager {
        DefaultLocationManager(locationPolicy: locationPolicy)
    }

    private struct ValidLocationPolicy: LocationPolicy {
        var validFor: TimeInterval = 0
        func isLocationValid(_ savedLocation: SavedLocation) -> Bool { true }
    }

    private struct InvalidLocationPolicy: LocationPolicy {
        var validFor: TimeInterval = 0
        func isLocationValid(_ savedLocation: SavedLocation) -> Bool { false }
    }


    
}

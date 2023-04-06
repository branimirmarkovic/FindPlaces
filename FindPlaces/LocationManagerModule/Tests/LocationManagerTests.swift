//
//  LocationManagerTests.swift
//  AppTests
//
//  Created by Branimir Markovic on 25.12.21..
//

import XCTest
@testable import FindPlaces
import CoreLocation

class SystemLocationManagerDecoratorTests: XCTestCase {
    var sut: SystemLocationManagerDecorator!
    var locationManager: MockCLLocationManager!
    var locationPolicy: MockLocationPolicy!

    override func setUp() {
        super.setUp()
        locationManager = MockCLLocationManager()
        locationPolicy = MockLocationPolicy()
        sut = SystemLocationManagerDecorator(locationPolicy: locationPolicy, locationManager: locationManager)
    }

    override func tearDown() {
        sut = nil
        locationManager = nil
        locationPolicy = nil
        super.tearDown()
    }

    func testCurrentLocation_callsStartUpdatingLocation_whenLocationInvalid() {
        locationPolicy.isValid = false
        sut.currentLocation { _ in }
        XCTAssertTrue(locationManager.didCallStartUpdatingLocation)
    }

    func testCurrentLocation_returnsSuccess_whenLocationValid() {
        locationPolicy.isValid = true
        let expectedLocation = CLLocation(latitude: 10, longitude: 10)
        let exp = expectation(description: "locationGet")
        var returnedLocation: CLLocation?
        sut.currentLocation { res in
            switch res {
            case .success(let location):
                returnedLocation = location
            case .failure(let error):
                XCTFail("Expected success but got \(String(describing: error))")
            }
            exp.fulfill()
        }
        sut.locationManager(locationManager, didUpdateLocations: [expectedLocation])
        
        wait(exp, timeout: PerformanceCenter.clientRequestsTimeLimit)
        XCTAssertEqual(returnedLocation, expectedLocation)
    }

    // Test if the completion handler is called when the location is updated
    func testLocationManager_didUpdateLocations_callsCompletion() {
        let expectedLocation = CLLocation(latitude: 10, longitude: 10)
        let locations: [CLLocation] = [expectedLocation]

        var result: Result<CLLocation, Error>?
        sut.currentLocation { res in
            result = res
        }

        sut.locationManager(locationManager, didUpdateLocations: locations)

        switch result {
        case .success(let location):
            XCTAssertEqual(location.coordinate.latitude, expectedLocation.coordinate.latitude)
            XCTAssertEqual(location.coordinate.longitude, expectedLocation.coordinate.longitude)
        default:
            XCTFail("Expected success but got \(String(describing: result))")
        }
    }

    // Test if an error is returned when there are no locations in the didUpdateLocations delegate method
    func testLocationManager_didUpdateLocationsNoLocations_returnsError() {
        let locations: [CLLocation] = []

        let exp = expectation(description: "")
        sut.currentLocation { result in
            switch result {
            case .failure(let error as NSError):
                XCTAssertEqual(error.domain, "No locations")
                XCTAssertEqual(error.code, 0)
            default:
                XCTFail("Expected failure but got \(String(describing: result))")
            }
            exp.fulfill()
        }
        sut.locationManager(locationManager, didUpdateLocations: locations)
        wait(exp, timeout: PerformanceCenter.clientRequestsTimeLimit)

        
    }

    // Test if the completion handler is called when the location manager reports an error
    func testLocationManager_didFailWithError_callsCompletion() {
        let expectedError = NSError(domain: "Location error", code: 1, userInfo: nil)
        let exp = expectation(description: "")

        sut.currentLocation { result in
            switch result {
            case .failure(let error as NSError):
                XCTAssertEqual(error.domain, expectedError.domain)
                XCTAssertEqual(error.code, expectedError.code)
            default:
                XCTFail("Expected failure but got \(String(describing: result))")
            }
            exp.fulfill()
        }

        sut.locationManager(locationManager, didFailWithError: expectedError)

        
        wait(for: [exp],timeout: PerformanceCenter.clientRequestsTimeLimit)
    }

    // Test if the location manager delegate is set to nil after completing
    func testLocationManager_delegateSetToNil_afterCompletion() {
        let expectedLocation = CLLocation(latitude: 10, longitude: 10)
        let locations: [CLLocation] = [expectedLocation]

        sut.currentLocation { _ in }

        sut.locationManager(locationManager, didUpdateLocations: locations)
        XCTAssertNil(self.locationManager.delegate)
        
    }

}

class MockCLLocationManager: CLLocationManager {
    var didCallStartUpdatingLocation = false

    override func startUpdatingLocation() {
        didCallStartUpdatingLocation = true
    }
}

class MockLocationPolicy: LocationPolicy {
    var validFor: TimeInterval = 0.0
    
    var isValid = false

    func isLocationValid(_ savedLocation: SavedLocation) -> Bool {
        return isValid
    }
}


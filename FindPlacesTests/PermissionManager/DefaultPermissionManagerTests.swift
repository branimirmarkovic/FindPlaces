//
//  DefaultPermissionManagerTests.swift
//  FindPlacesTests
//
//  Created by Branimir Markovic on 6.4.23..
//

import XCTest
@testable import FindPlaces
import CoreLocation


class DefaultPermissionManagerTests: XCTestCase {
    
    var locationManager: MockLocationManager!
    var permissionManager: DefaultPermissionManager!
    
    override func setUp() {
        super.setUp()
        locationManager = MockLocationManager()
        permissionManager = DefaultPermissionManager(locationManager: locationManager)
    }
    
    override func tearDown() {
        locationManager = nil
        permissionManager = nil
        super.tearDown()
    }
    
    func testIsLocationPermitted_whenAuthorizedWhenInUse_returnsAllowed() {
        locationManager.authorizationStatusToReturn = .authorizedWhenInUse
        XCTAssertEqual(permissionManager.isLocationPermitted(), .allowed)
    }
    
    func testIsLocationPermitted_whenDenied_returnsDenied() {
        locationManager.authorizationStatusToReturn = .denied
        XCTAssertEqual(permissionManager.isLocationPermitted(), .denied)
    }
    
    func testAskLocationPermission_whenAuthorizedWhenInUse_callsCompletionWithAllowed() {
        locationManager.authorizationStatusToReturn = .authorizedWhenInUse
        let expectation = self.expectation(description: "Expecting .allowed callback")
        permissionManager.askLocationPermission { status in
            XCTAssertEqual(status, .allowed)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1)
    }
    
    func testAskLocationPermission_whenDenied_callsCompletionWithDenied() {
        locationManager.authorizationStatusToReturn = .denied
        let expectation = self.expectation(description: "Expecting .denied callback")
        permissionManager.askLocationPermission { status in
            XCTAssertEqual(status, .denied)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1)
    }
}

class MockLocationManager: CLLocationManager {
    var authorizationStatusToReturn: CLAuthorizationStatus = .notDetermined
    
    override var authorizationStatus: CLAuthorizationStatus {
        return authorizationStatusToReturn
    }
    
    override func requestWhenInUseAuthorization() {}
}


//
//  POICategoriesLoader.swift
//  App
//
//  Created by Branimir Markovic on 18.12.21..
//

import Foundation
import MapKit

protocol POICategoriesLoader {
    func load(completion: @escaping(Result<[PointOfInterestCategory],Error>) -> Void)
}

class AppleMapPOICategoriesLoader: POICategoriesLoader {
    func load(completion: @escaping (Result<[PointOfInterestCategory], Error>) -> Void) {
        completion(.success(PointOfInterestCategory.allCases))
    }
}

enum PointOfInterestCategory: CaseIterable {
    case airport
    case amusementPark
    case aquarium
    case atm
    case bakery
    case bank
    case beach
    case brewery
    case cafe
    case campground
    case carRental
    case evCharger
    case fireStation
    case fitnessCenter
    case foodMarket
    case gasStation
    case hospital
    case hotel
    case laundry
    case library
    case marina
    case movieTheater
    case museum
    case nationalPark
    case nightlife
    case park
    case parking
    case pharmacy
    case police
    case postOffice
    case publicTransport
    case restaurant
    case restroom
    case school
    case stadium
    case store
    case theater
    case university
    case winery
    case zoo
    case unknow
}

extension PointOfInterestCategory {
    
    func localizedDisplayString() -> String {
        switch self {
        case .airport:
            return NSLocalizedString("Airport", comment: "")
        case .amusementPark:
            return NSLocalizedString("Amusement Park", comment: "")
        case .aquarium:
            return NSLocalizedString("Aquarium", comment: "")
        case .atm:
            return NSLocalizedString("ATM", comment: "")
        case .bakery:
            return NSLocalizedString("Bakery", comment: "")
        case .bank:
            return NSLocalizedString("Bank", comment: "")
        case .beach:
            return NSLocalizedString("Beach", comment: "")
        case .brewery:
            return NSLocalizedString("Brewery", comment: "")
        case .cafe:
            return NSLocalizedString("Cafe", comment: "")
        case .campground:
            return NSLocalizedString("Campground", comment: "")
        case .carRental:
            return NSLocalizedString("Car Rental", comment: "")
        case .evCharger:
            return NSLocalizedString("EV Charger", comment: "")
        case .fireStation:
            return NSLocalizedString("Fire Station", comment: "")
        case .fitnessCenter:
            return NSLocalizedString("Fitness Center", comment: "")
        case .foodMarket:
            return NSLocalizedString("Food Market", comment: "")
        case .gasStation:
            return NSLocalizedString("Gas Station", comment: "")
        case .hospital:
            return NSLocalizedString("Hospital", comment: "")
        case .hotel:
            return NSLocalizedString("Hotel", comment: "")
        case .laundry:
            return NSLocalizedString("Laundry", comment: "")
        case .library:
            return NSLocalizedString("Library", comment: "")
        case .marina:
            return NSLocalizedString("Marina", comment: "")
        case .movieTheater:
            return NSLocalizedString("Movie Theater", comment: "")
        case .museum:
            return NSLocalizedString("Museum", comment: "")
        case .nationalPark:
            return NSLocalizedString("National Park", comment: "")
        case .nightlife:
            return NSLocalizedString("Nightlife", comment: "")
        case .park:
            return NSLocalizedString("Park", comment: "")
        case .parking:
            return NSLocalizedString("Parking", comment: "")
        case .pharmacy:
            return NSLocalizedString("Pharmacy", comment: "")
        case .police:
            return NSLocalizedString("Police", comment: "")
        case .postOffice:
            return NSLocalizedString("Post Office", comment: "")
        case .publicTransport:
            return NSLocalizedString("Public Transport", comment: "")
        case .restaurant:
            return NSLocalizedString("Restaurant", comment: "")
        case .restroom:
            return NSLocalizedString("Restroom", comment: "")
        case .school:
            return NSLocalizedString("School", comment: "")
        case .stadium:
            return NSLocalizedString("Stadium", comment: "")
        case .store:
            return NSLocalizedString("Store", comment: "")
        case .theater:
            return NSLocalizedString("Theater", comment: "")
        case .university:
            return NSLocalizedString("University", comment: "")
        case .winery:
            return NSLocalizedString("Winery", comment: "")
        case .zoo:
            return NSLocalizedString("Zoo", comment: "")
        case .unknow:
            return NSLocalizedString("Unknown", comment: "")
        @unknown default:
            return NSLocalizedString("Unknown", comment: "")
        }
    }
}


 

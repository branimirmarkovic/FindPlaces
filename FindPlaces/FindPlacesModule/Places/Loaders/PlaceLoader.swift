//
//  PlaceLoader.swift
//  App
//
//  Created by Branimir Markovic on 18.12.21..
//

import Foundation

struct LoadRegion {
    var center: Coordinates
    var latitudeDelta: Double
    var longitudeDelta: Double
}

protocol PointsOfInterestLoader {
    func load(categories: [PointOfInterestCategory], inRegion loadRegion: LoadRegion, completion: @escaping(Result<[PointOfInterest],Error>) -> Void)
}

class MockPointsOfInterestLoader: PointsOfInterestLoader {
    func load(categories: [PointOfInterestCategory], inRegion loadRegion: LoadRegion, completion: @escaping (Result<[PointOfInterest], Error>) -> Void) {
        completion(.failure(NSError()))
    }
}

import MapKit

class MKMapPOILoader: PointsOfInterestLoader {
    func load(categories: [PointOfInterestCategory], inRegion loadRegion: LoadRegion, completion: @escaping (Result<[PointOfInterest], Error>) -> Void) {
        let request = MKLocalPointsOfInterestRequest(coordinateRegion: MKCoordinateRegion(loadRegion: loadRegion))
        if categories.isEmpty == false {
            request.pointOfInterestFilter = MKPointOfInterestFilter(including: categories.compactMap({$0.toMKPointOfInterestCategory()}))
        }
        let search = MKLocalSearch(request: request)
        search.start { response, error in
            if let response {
                completion(.success(response.mapItems.map({$0.toPointOfInterest()})))
                return
            }
            if let error = error as? MKError {
                switch error.code {
                case .placemarkNotFound:
                    completion(.success([]))
                default:
                    completion(.failure(error))
                }
            }
        }   
    }
}

extension MKCoordinateRegion {
    init(loadRegion: LoadRegion) {
        self.init(
            center: 
                CLLocationCoordinate2D(
                    latitude: loadRegion.center.latitude,
                    longitude: loadRegion.center.longitude),
            span: MKCoordinateSpan(
                latitudeDelta: loadRegion.latitudeDelta,
                longitudeDelta: loadRegion.longitudeDelta))
    }
}
 extension MKCoordinateRegion {
    func toLoadRegion() -> LoadRegion {
        LoadRegion(
            center: Coordinates(
                latitude: self.center.latitude,
                longitude: self.center.longitude),
            latitudeDelta: self.span.latitudeDelta,
            longitudeDelta: self.center.longitude)
    }
}

extension MKMapItem {
    func toPointOfInterest() -> PointOfInterest {
        PointOfInterest(
            name: self.name ?? "", 
            coordinates: 
                Coordinates(
                    latitude: self.placemark.coordinate.latitude,
                    longitude: self.placemark.coordinate.longitude),
            phoneNumber: self.phoneNumber,
            poiCategory: PointOfInterestCategory(self.pointOfInterestCategory))
    }
}

fileprivate extension PointOfInterestCategory {
    func toMKPointOfInterestCategory() -> MKPointOfInterestCategory? {
        switch self {
        case .airport:
            return .airport
        case .amusementPark:
            return .amusementPark
        case .aquarium:
            return .aquarium
        case .atm:
            return .atm
        case .bakery:
            return .bakery
        case .bank:
            return .bank
        case .beach:
            return .beach
        case .brewery:
            return .brewery
        case .cafe:
            return .cafe
        case .campground:
            return .campground
        case .carRental:
            return .carRental
        case .evCharger:
            return .evCharger
        case .fireStation:
            return .fireStation
        case .fitnessCenter:
            return .fitnessCenter
        case .foodMarket:
            return .foodMarket
        case .gasStation:
            return .gasStation
        case .hospital:
            return .hospital
        case .hotel:
            return .hotel
        case .laundry:
            return .laundry
        case .library:
            return .library
        case .marina:
            return .marina
        case .movieTheater:
            return .movieTheater
        case .museum:
            return .museum
        case .nationalPark:
            return .nationalPark
        case .nightlife:
            return .nightlife
        case .park:
            return .park
        case .parking:
            return .parking
        case .pharmacy:
            return .pharmacy
        case .police:
            return .police
        case .postOffice:
            return .postOffice
        case .publicTransport:
            return .publicTransport
        case .restaurant:
            return .restaurant
        case .restroom:
            return .restroom
        case .school:
            return .school
        case .stadium:
            return .stadium
        case .store:
            return .store
        case .theater:
            return .theater
        case .university:
            return .university
        case .winery:
            return .winery
        case .zoo:
            return .zoo
        case .unknow:
            return nil
        }
    }
}

fileprivate extension PointOfInterestCategory {
    init(_ category: MKPointOfInterestCategory?) {
        guard let category else {
            self = Self.unknow
            return 
        }
        
        switch category {
        case .airport:
            self = .airport
        case .amusementPark:
            self = .amusementPark
        case .aquarium:
            self = .aquarium
        case .atm:
            self = .atm
        case .bakery:
            self = .bakery
        case .bank:
            self = .bank
        case .beach:
            self = .beach
        case .brewery:
            self = .brewery
        case .cafe:
            self = .cafe
        case .campground:
            self = .campground
        case .carRental:
            self = .carRental
        case .evCharger:
            self = .evCharger
        case .fireStation:
            self = .fireStation
        case .fitnessCenter:
            self = .fitnessCenter
        case .foodMarket:
            self = .foodMarket
        case .gasStation:
            self = .gasStation
        case .hospital:
            self = .hospital
        case .hotel:
            self = .hotel
        case .laundry:
            self = .laundry
        case .library:
            self = .library
        case .marina:
            self = .marina
        case .movieTheater:
            self = .movieTheater
        case .museum:
            self = .museum
        case .nationalPark:
            self = .nationalPark
        case .nightlife:
            self = .nightlife
        case .park:
            self = .park
        case .parking:
            self = .parking
        case .pharmacy:
            self = .pharmacy
        case .police:
            self = .police
        case .postOffice:
            self = .postOffice
        case .publicTransport:
            self = .publicTransport
        case .restaurant:
            self = .restaurant
        case .restroom:
            self = .restroom
        case .school:
            self = .school
        case .stadium:
            self = .stadium
        case .store:
            self = .store
        case .theater:
            self = .theater
        case .university:
            self = .university
        case .winery:
            self = .winery
        case .zoo:
            self = .zoo
        default:
            self = .unknow
        }
    }
}

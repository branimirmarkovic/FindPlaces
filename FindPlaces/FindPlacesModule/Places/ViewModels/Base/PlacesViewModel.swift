//
//  PlacesViewModel.swift
//  App
//
//  Created by Branimir Markovic on 18.12.21..
//

import Foundation
import CoreLocation


class PlacesViewModel {

    private let pointOfInterestsLoader: PointsOfInterestLoader
    private let imagesLoader: ImageLoader
    private var places: [PlaceViewModel] = []

    init(pointOfInterestsLoader: PointsOfInterestLoader, imagesLoader: ImageLoader) {
        self.pointOfInterestsLoader = pointOfInterestsLoader
        self.imagesLoader = imagesLoader
    }

    var onLoadStart: (() -> Void)?
    var didLoad: (()-> Void)?
    var onError: ((String)->Void)?
    
    

    func load(type: PointOfInterestCategory, inRegion: LoadRegion) {
        places.removeAll()
        onLoadStart?()
        pointOfInterestsLoader.load(categories: [type], inRegion: inRegion) {[weak self] result in
            guard let self = self else {return}
            switch result {
            case.success(let pointsOfInterest):
                self.places = pointsOfInterest.map({PlaceViewModel(place: $0, imageLoader: self.imagesLoader)})
                self.didLoad?()
            case.failure(let error):
                self.onError?(self.errorMessage(for: error))
            }
        }
    }

    var placesCount: Int {
        places.count
    }


    func place(at index: Int) -> PlaceViewModel? {
        guard index < places.count else {return nil}
        return self.places[index]
    }
    
    func place(atLocation location: Coordinates) -> PlaceViewModel?  {
        places.first { $0.latitude == location.latitude && $0.longitude == location.longitude }
    }

    func allPlaces() -> [PlaceViewModel] {
        self.places
    }
    private func errorMessage(for error: Error) -> String {
        // TODO: - Format error message
        "Something went wrong..."
    }
}

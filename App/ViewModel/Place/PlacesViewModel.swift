//
//  PlacesViewModel.swift
//  App
//
//  Created by Branimir Markovic on 18.12.21..
//

import Foundation
import CoreLocation


class PlacesViewModel {
    private var loader: PlacesLoader
    private var places: [PlaceViewModel] = []

    init(loader: PlacesLoader) {
        self.loader = loader
    }

    var onLoad: (()-> Void)?
    var onObtainingLocation: ((CLLocation) -> Void)?
    var onError: ((String)->Void)?

    func load(type: String = "", orderBy: OrderOptions = .score) {
        loader.load(placeType: type, orderBy: orderBy) {[weak self] result in
            guard let self = self else {return}
            switch result {
            case.success(let places):
                self.places = places.results.map({PlaceViewModel(place: $0)})
                self.onLoad?()
                self.loader.userLocation { [weak self] result in
                    guard let self = self else {return}
                    switch result {
                    case .success(let location):
                        self.onObtainingLocation?(location)
                    case .failure(let error):
                        self.onError?(self.errorMessage(for: error))
                    }
                }
            case.failure(let error):
                self.onError?(self.errorMessage(for: error))
            }
        }
    }


    var placesCount: Int {
        places.count
    }

    private func errorMessage(for error: Error) -> String {
        "Something went wrong..."
    }

    func place(at index: Int) -> PlaceViewModel? {
        guard index < places.count else {return nil}
        return self.places[index]
    }

    func allPlaces() -> [PlaceViewModel] {
        self.places
    }
}

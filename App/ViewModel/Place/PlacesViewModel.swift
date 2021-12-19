//
//  PlacesViewModel.swift
//  App
//
//  Created by Branimir Markovic on 18.12.21..
//

import Foundation


class PlacesViewModel {
    var loader: PlacesLoader
    private var places: [PlaceViewModel] = []

    init(loader: PlacesLoader) {
        self.loader = loader
    }

    var onLoad: (([PlaceViewModel])-> Void)?
    var onError: ((String)->Void)?

    func load(type: String = "") {
        loader.load(placeType: type) {[weak self] result in
            guard let self = self else {return}
            switch result {
            case.success(let places):
                self.places = places.results.map({PlaceViewModel(place: $0)})
                self.onLoad?(self.places)
            case.failure(let error):
                self.onError?(self.errorMessage(for: error))
            }
        }
    }

    var placesCount: Int {
        places.count
    }

    func places(for selectedType: String) -> [PlaceViewModel] {
       []
    }

    func places(by distance: Double) -> [PlaceViewModel] {
        []
    }

    func errorMessage(for error: Error) -> String {
        "Something went wrong..."
    }

    func place(at index: Int) -> PlaceViewModel? {
        guard index < places.count else {return nil}
        return self.places[index]
    }
}

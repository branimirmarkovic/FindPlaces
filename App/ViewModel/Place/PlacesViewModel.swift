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
    var onError: ((Error)->Void)?

    func load(type: String = "") {
        loader.load(placeType: type) {[weak self] result in
            guard let self = self else {return}
            switch result {
            case.success(let places):
                self.places = places.map({PlaceViewModel(place: $0)})
                self.onLoad?(self.places)
            case.failure(let error):
                self.onError?(error)
            }
        }
        
    }

    var placesCount: Int {
        places.count
    }

    func places(for selectedType: String) -> [PlacesViewModel] {
       []
    }

    func places(by distance: Double) -> [PlacesLoader] {
        []
    }
}

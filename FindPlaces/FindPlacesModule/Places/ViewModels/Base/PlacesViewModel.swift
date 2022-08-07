//
//  PlacesViewModel.swift
//  App
//
//  Created by Branimir Markovic on 18.12.21..
//

import Foundation
import CoreLocation


class PlacesViewModel {

    private let loader: PlacesLoader
    private let imagesLoader: ImageLoader
    private let dataCachePolicy: DataCachePolicy
    private var places: [PlaceViewModel] = []
    
    private var morePlacesAvailableToLoad: Bool = false

    init(loader: PlacesLoader, imagesLoader: ImageLoader, dataCachePolicy: DataCachePolicy) {
        self.loader = loader
        self.imagesLoader = imagesLoader
        self.dataCachePolicy = dataCachePolicy
    }

    var onLoadStart: (() -> Void)?
    var didLoad: (()-> Void)?
    var onError: ((String)->Void)?
    
    

    func load(type: String = "eatingout", orderBy: OrderOptions = .score) {
        places.removeAll()
        onLoadStart?()
        loader.load(placeType: type, orderBy: orderBy) {[weak self] result in
            guard let self = self else {return}
            switch result {
            case.success(let placesTuple):
                self.places = placesTuple.places.map({PlaceViewModel(place: $0, imageLoader: self.imagesLoader)})
                self.morePlacesAvailableToLoad = placesTuple.isThereMore
                self.didLoad?()
            case.failure(let error):
                self.onError?(self.errorMessage(for: error))
            }
        }
    }
// TODO: - Think about what shold be time validable, current implementation is not working beacuse data returned from server is not acessible here, and view model should manage loading and chaching
    private func checkIfLoadIsNecessary() -> Bool {
        true
    }

    var placesCount: Int {
        places.count
    }


    func place(at index: Int) -> PlaceViewModel? {
        guard index < places.count else {return nil}
        return self.places[index]
    }

    func allPlaces() -> [PlaceViewModel] {
        self.places
    }
    
    func isMorePlacesAvailable() -> Bool {
        morePlacesAvailableToLoad
    }

    private func errorMessage(for error: Error) -> String {
        // TODO: - Format error message
        "Something went wrong..."
    }
}

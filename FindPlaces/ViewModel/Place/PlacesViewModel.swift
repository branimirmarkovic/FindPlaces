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

    init(loader: PlacesLoader, imagesLoader: ImageLoader, dataCachePolicy: DataCachePolicy) {
        self.loader = loader
        self.imagesLoader = imagesLoader
        self.dataCachePolicy = dataCachePolicy
    }

    var onLoadStart: (() -> Void)?
    var onLoad: (()-> Void)?
    var onObtainingLocation: ((CLLocation) -> Void)?
    var onError: ((String)->Void)?

    func load(type: String = "eatingout", orderBy: OrderOptions = .score) {
        places.removeAll()
        onLoadStart?()
        loader.load(placeType: type, orderBy: orderBy) {[weak self] result in
            guard let self = self else {return}
            switch result {
            case.success(let places):
                self.places = places.results.map({PlaceViewModel(place: $0, imageLoader: self.imagesLoader)})
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
// TODO: - Think about what shold be time validable, current implementation is not working beacuse data returned from server is not acessible here, and view model should manage loading and chaching
    private func checkIfLoadIsNecessary() -> Bool {
        dataCachePolicy.isDataValid(of: <#T##TimeValidable#>)

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

    private func errorMessage(for error: Error) -> String {
        // TODO: - Format error message
        "Something went wrong..."
    }
}

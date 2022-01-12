//
//  MainpageCompositeViewModel.swift
//  App
//
//  Created by Branimir Markovic on 12.1.22..
//

import Foundation
import CoreLocation

class MainPageCompositeViewModel {

    private let placesLoader: PlacesLoader
    private let tagsLoader: TagsLoader
    private let imagesLoader: ImageLoader
    private var places: [PlaceViewModel] = []
    private var tags: [TagViewModel] = []
    private var isThereMoreTags: Bool = false

    init(placesLoader: PlacesLoader, imagesLoader: ImageLoader, tagsLoader: TagsLoader) {
        self.placesLoader = placesLoader
        self.imagesLoader = imagesLoader
        self.tagsLoader = tagsLoader
    }

    var onLoad: (()-> Void)?
    var onObtainingLocation: ((CLLocation) -> Void)?
    var onError: ((String)->Void)?

    private func loadPlaces(type: String = "", orderBy: OrderOptions = .score, ) {
        placesLoader.load(placeType: type, orderBy: orderBy) {[weak self] result in
            guard let self = self else {return}
            switch result {
            case.success(let places):
                self.places = places.results.map({PlaceViewModel(place: $0, imageLoader: self.imagesLoader)})
                self.placesLoader.userLocation { [weak self] result in
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

    private func loadTags(completion: @escaping (Result<Void,Error>) -> Void) {
        tagsLoader.load {[weak self] result in
            guard let self = self else {return}
            switch result  {
            case .success(let tags):
                self.tags = tags.results.map({TagViewModel(tag: $0)})
                self.isThereMoreTags = tags.more
                self.onLoad?()
            case .failure(let error):
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

    func allPlaces() -> [PlaceViewModel] {
        self.places
    }

    private func errorMessage(for error: Error) -> String {
        // TODO: - Format error message
        "Something went wrong..."
    }

    var tagsCount: Int {
        tags.count
    }

    var isMoreBadgeVisible: Bool {
        isThereMoreTags
    }

    func tag(at index: Int) -> TagViewModel? {
        guard index < tags.count else {return nil}
        return self.tags[index]
    }

    func selectedTag(at index: Int,reloadWith placesViewModel: PlacesViewModel) {
        let tagLabel = tags[index].tagSearchLabel
        placesViewModel.load(type: tagLabel)
    }

}

//
//  MainpageCompositeViewModel.swift
//  App
//
//  Created by Branimir Markovic on 12.1.22..
//

import Foundation
import CoreLocation

class MainPageCompositeViewModel {

     let placesViewModel: PlacesViewModel
     let tagsViewModel: TagsViewModel

    init(placesViewModel: PlacesViewModel, tagsViewModel: TagsViewModel) {
        self.placesViewModel = placesViewModel
        self.tagsViewModel = tagsViewModel
        bind()
    }

    var onTagsUpdateStart: (() -> Void)?
    var onTagsLoad: (() -> Void)?

    var onPlacesUpdateStart: (() -> Void)?
    var onPlacesLoad: (() -> Void)?
    var onError: ((String)->Void)?

    func load() {
        onTagsUpdateStart?()
        tagsViewModel.load()
    }


    private func bind() {
        tagsViewModel.onError = { [weak self] error  in
            self?.placesViewModel.load()
            self?.onError?(error)

        }

        tagsViewModel.onLoad = { [weak self] in
            self?.onPlacesUpdateStart?()
            self?.placesViewModel.load()
            self?.onTagsLoad?()
        }

        placesViewModel.onLoad = {[weak self] in
            self?.onPlacesLoad?()

        }

        placesViewModel.onError = { [weak self]error in
            self?.onError?(error)

        }
    }
}

//
//  MainpageCompositeViewModel.swift
//  App
//
//  Created by Branimir Markovic on 12.1.22..
//

import Foundation

class MainPageCompositeViewModel {

     private let placesViewModel: PlacesViewModel
     private let tagsViewModel: TagsViewModel

    init(placesViewModel: PlacesViewModel, tagsViewModel: TagsViewModel) {
        self.placesViewModel = placesViewModel
        self.tagsViewModel = tagsViewModel
        bind()
    }

    var onTagsLoadStart: (() -> Void)?
    var onTagsLoad: (() -> Void)?

    var onPlacesLoadStart: (() -> Void)?
    var onPlacesLoad: (() -> Void)?
    
    var onCompleteLoad: (() -> Void)?
    var onError: ((String)->Void)?

    func load() {
        tagsViewModel.load()
        placesViewModel.load()
    }
    
    // MARK: - Tag Interface
    
    var tagsCount: Int {
        tagsViewModel.tagsCount
    }

    var areMoreTagsAvailable: Bool {
        tagsViewModel.areMoreTagsAvailable
    }

    func tag(at index: Int) -> TagViewModel? {
        tagsViewModel.tag(at: index)
    }
    
    // MARK: - Places Interface
    
    var placesCount: Int {
        placesViewModel.placesCount
    }


    func place(at index: Int) -> PlaceViewModel? {
        placesViewModel.place(at: index)
    }

    func allPlaces() -> [PlaceViewModel] {
        placesViewModel.allPlaces()
    }
    
    func isMorePlacesAvailable() -> Bool {
        placesViewModel.isMorePlacesAvailable()
    }


    // MARK: - Private Methods
    
    private var placesLoaded: Bool = false {
        didSet {
            checkForCompletionOfLoad()
        }
    }
    private var tagsLoaded: Bool = false {
        didSet {
            checkForCompletionOfLoad()
        }
    }
    
    private func checkForCompletionOfLoad() {
        guard placesLoaded && tagsLoaded else {return}
        onCompleteLoad?()
        placesLoaded = false
        tagsLoaded = false
    }
    
    
    private func bind() {
        
        tagsViewModel.onLoadStart = { [weak self] in 
            self?.onTagsLoadStart?()
        }
        
        tagsViewModel.onError = { [weak self] error  in
            self?.onError?(error)
        }

        tagsViewModel.didLoad = { [weak self] in
            self?.tagsLoaded = true
            self?.onTagsLoad?()
        }
        
        placesViewModel.onLoadStart = { [weak self] in
            self?.onPlacesLoadStart?()
            
        }

        placesViewModel.didLoad = {[weak self] in
            self?.placesLoaded = true
            self?.onPlacesLoad?()
        }

        placesViewModel.onError = { [weak self]error in
            self?.onError?(error)
        }
    }
}

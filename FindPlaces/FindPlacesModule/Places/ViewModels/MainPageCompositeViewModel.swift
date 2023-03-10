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
    
    private let internalStartingLocation: Coordinates

    init(
        placesViewModel: PlacesViewModel, 
        tagsViewModel: TagsViewModel,
        startingLocation: Coordinates) {
        self.placesViewModel = placesViewModel
        self.tagsViewModel = tagsViewModel
            self.internalStartingLocation = startingLocation
        bind()
    }

    var onTagsLoadStart: (() -> Void)?
    var onTagsLoad: (() -> Void)?
    var onTagSelection: (() -> Void)?

    var onPlacesLoadStart: (() -> Void)?
    var onPlacesLoad: (() -> Void)?
    var onPlaceSelection:((PlaceViewModel?) -> Void)?
    
    var onCompleteLoad: (() -> Void)?
    var onError: ((String)->Void)?

    func load() {
        tagsViewModel.load()
        placesViewModel.load()
    }
    
    func selectTag(at index: Int) {
        tagsViewModel.selectTag(at: index)
        placesViewModel.load(type: tagsViewModel.tag(at: index)!.tagSearchLabel, orderBy: .distance)
    }
    
    func selectPlace( atLocation location: Coordinates) {
        let placeViewModel = placesViewModel.place(atLocation: location)
        onPlaceSelection?(placeViewModel)
    }
    
    var startingLocation: Coordinates {
        self.internalStartingLocation
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
    
    func tagSectionTitle() -> String {
        tagsViewModel.sectionTitle()
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
        
        tagsViewModel.onTagSelection = { [weak self] in 
            self?.onTagSelection?()
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

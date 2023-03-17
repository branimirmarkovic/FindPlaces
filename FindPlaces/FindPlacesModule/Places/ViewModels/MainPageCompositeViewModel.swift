//
//  MainpageCompositeViewModel.swift
//  App
//
//  Created by Branimir Markovic on 12.1.22..
//

import Foundation

class MainPageCompositeViewModel {

    private let placesViewModel: PlacesViewModel
    private let poiCategoriesViewModel: POICategoriesViewModel

    let startingRegion: LoadRegion

    init(
        placesViewModel: PlacesViewModel, 
        poiCategoriesViewModel: POICategoriesViewModel,
        startingLocation: Coordinates) {
        self.placesViewModel = placesViewModel
        self.poiCategoriesViewModel = poiCategoriesViewModel
            self.startingRegion = LoadRegion(
                center: Coordinates(
                    latitude: startingLocation.latitude - 0.004,
                    longitude: startingLocation.longitude),
                latitudeDelta: 0.02,
                longitudeDelta: 0.02)
        bind()
    }

    var onPOICategoriesLoadStart: (() -> Void)?
    var onPOICategoriesLoad: (() -> Void)?
    var onPOICategoriesSelection: (() -> Void)?

    var onPlacesLoadStart: (() -> Void)?
    var onPlacesLoad: (() -> Void)?
    var onPlaceSelection:((PlaceViewModel?) -> Void)?
    
    var onCompleteLoad: (() -> Void)?
    var onError: ((String)->Void)?

    func load(in region: LoadRegion) {
        poiCategoriesViewModel.load()
        placesViewModel.load(type: .restaurant, inRegion: region)
    }
    
    func selectCategory(at index: Int) {
        poiCategoriesViewModel.selectCategory(at: index)
        placesViewModel.load(type: poiCategoriesViewModel.selectedCategory(), inRegion: startingRegion)
    }
    
    func deselectSelectedCategory() {
        poiCategoriesViewModel.deselectSelectedCategory()
        placesViewModel.load(type: poiCategoriesViewModel.selectedCategory(), inRegion: startingRegion) 
    }
    
    func selectPlace( atLocation location: Coordinates) {
        let placeViewModel = placesViewModel.place(atLocation: location)
        onPlaceSelection?(placeViewModel)
    }
    
    // MARK: - POICategories Interface
    
    var categoriesCountCount: Int {
        poiCategoriesViewModel.categoriesCount
    }

    func category(at index: Int) -> PointOfInterestCategoryViewModel? {
        poiCategoriesViewModel.category(at: index)
    }
    
    func poiCategoriesSectionTitle() -> String {
        poiCategoriesViewModel.sectionTitle()
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
    
    func selectedCategoryViewModel() -> PointOfInterestCategoryViewModel? {
        poiCategoriesViewModel.selectedCategoryViewModel()
    }
    


    // MARK: - Private Methods
    
    private var placesLoaded: Bool = false {
        didSet {
            checkForCompletionOfLoad()
        }
    }
    private var poiCategoriesLoaded: Bool = false {
        didSet {
            checkForCompletionOfLoad()
        }
    }
    
    private func checkForCompletionOfLoad() {
        guard placesLoaded && poiCategoriesLoaded else {return}
        onCompleteLoad?()
        placesLoaded = false
        poiCategoriesLoaded = false
    }
    
    
    private func bind() {
        
        poiCategoriesViewModel.onLoadStart = { [weak self] in 
            self?.onPOICategoriesLoadStart?()
        }
        
        poiCategoriesViewModel.onPOICategorySelection = { [weak self] in 
            self?.onPOICategoriesSelection?()
        }
        
        poiCategoriesViewModel.onError = { [weak self] error  in
            self?.onError?(error)
        }

        poiCategoriesViewModel.didLoad = { [weak self] in
            self?.poiCategoriesLoaded = true
            self?.onPOICategoriesLoad?()
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

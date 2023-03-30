//
//  POICategoriesViewModel.swift
//  App
//
//  Created by Branimir Markovic on 18.12.21..
//

import Foundation


class POICategoriesViewModel {

    private let loader: POICategoriesLoader

    private var pointOfInterestCategories: [PointOfInterestCategoryViewModel] = []
    private var selectedCategory: PointOfInterestCategoryViewModel? {
        pointOfInterestCategories.first(where: {$0.isSelected})
    }
    private var unselectedCategories: [PointOfInterestCategoryViewModel] {
        pointOfInterestCategories.filter({$0.isSelected == false})
    }

    var onLoadStart: (() -> Void)?
    var didLoad:(()-> Void)?
    var onPOICategorySelection: (() -> Void)?
    var onError: ((String) -> Void)?

    init(loader: POICategoriesLoader) {
        self.loader = loader
    }

    func load() {
        onLoadStart?()
        loader.load {[weak self] result in
            guard let self = self else {return}
            switch result  {
            case .success(let pointIfInterestCategories):
                self.pointOfInterestCategories = pointIfInterestCategories.map({PointOfInterestCategoryViewModel(poi: $0)})
                self.didLoad?()
            case .failure(let error):
                self.onError?(self.errorMessage(for: error))
            }
        }
    }
    
    func selectCategory(at index: Int) {
        guard let category = category(at: index) else {
            onError?("Cant Select Category")
            return
        }
        if category.isSelected {
            pointOfInterestCategories.forEach({$0.isSelected = false})
        } else {
            pointOfInterestCategories.forEach({$0.isSelected = false})
            category.isSelected.toggle()
        }
        onPOICategorySelection?()
    }
    
    func deselectSelectedCategory() {
        pointOfInterestCategories.forEach({$0.isSelected = false})
        onPOICategorySelection?()
    }

    var unselectedCategoriesCount: Int {
        self.unselectedCategories.count
    }
    
    func selectedPOICategory() -> PointOfInterestCategory? {
        self.selectedCategory?.category
    }
    
    func selectedCategoryViewModel() -> PointOfInterestCategoryViewModel? {
        selectedCategory
    }


    func category(at index: Int) -> PointOfInterestCategoryViewModel? {
        guard index < unselectedCategories.count else {return nil}
        return self.unselectedCategories[index]
    }
    
    func sectionTitle() -> String {
        var result = "All"
        pointOfInterestCategories.forEach({
            if $0.isSelected == true {
                result = $0.name
            }
        })
        
        return result
    }

    func selectedCategory(at index: Int, reloadWith placesViewModel: PlacesViewModel) {
//        let tagLabel = tags[index].tagSearchLabel
//        placesViewModel.load(type: tagLabel)
    }
    
    // MARK: - Private Methods
    
    private func errorMessage(for error: Error) -> String {
        "Something went wrong..."
    }
}

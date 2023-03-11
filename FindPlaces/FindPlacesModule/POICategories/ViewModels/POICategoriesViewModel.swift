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
        sortCategories()
        onPOICategorySelection?()
    }

    var categoriesCount: Int {
        pointOfInterestCategories.count
    }
    
    func selectedCategory() -> PointOfInterestCategory? {
        pointOfInterestCategories.first(where: {$0.isSelected})?.category
    }


    func category(at index: Int) -> PointOfInterestCategoryViewModel? {
        guard index < pointOfInterestCategories.count else {return nil}
        return self.pointOfInterestCategories[index]
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
    
    private func sortCategories() {
        let selectedCategories = pointOfInterestCategories.filter({ $0.isSelected })
        var unselectedCategories = pointOfInterestCategories.filter({ $0.isSelected == false})
        unselectedCategories.sort(by: {$0.name.lowercased() < $1.name.lowercased()})
        pointOfInterestCategories = selectedCategories + unselectedCategories
    }
    
    // MARK: - Private Methods
    
    private func errorMessage(for error: Error) -> String {
        "Something went wrong..."
    }
}

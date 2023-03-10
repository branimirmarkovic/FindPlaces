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
        category.isSelected.toggle()
        pointOfInterestCategories.sort { leftCategory, rightCategory in
            leftCategory.isSelected && rightCategory.isSelected == false
        }
        onPOICategorySelection?()
    }

    var categoriesCount: Int {
        pointOfInterestCategories.count
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
    
    // MARK: - Private Methods
    
    private func errorMessage(for error: Error) -> String {
        "Something went wrong..."
    }
}

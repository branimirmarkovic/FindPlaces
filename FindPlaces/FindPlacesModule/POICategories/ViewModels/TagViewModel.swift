//
//  PointOfInterestCategoryViewModel.swift
//  App
//
//  Created by Branimir Markovic on 18.12.21..
//

import Foundation


class PointOfInterestCategoryViewModel {

    private var poi: PointOfInterestCategory
    
    var selectionHandler: (() -> Void)?

    init(poi: PointOfInterestCategory) {
        self.poi = poi
    }
    
    var isSelected: Bool = false
    
    
    var name: String {
        poi.localizedDisplayString()
    }
    var category: PointOfInterestCategory {
        poi
    }

}

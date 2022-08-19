//
//  TagViewModel.swift
//  App
//
//  Created by Branimir Markovic on 18.12.21..
//

import Foundation


class TagViewModel {

    private var tag: Tag

    init(tag: Tag) {
        self.tag = tag
    }
    
    var isSelected: Bool = false
    
    
    var name: String {
        tag.name
    }

    var numberOfLocations: String {
        "\(tag.pointOfInterestCount)"
    }

    var score: String {
        "\((tag.score * 0.5).roundToDecimal(2))/5"
    }

    var tagSearchLabel: String {
        tag.label
    }

}

//
//  PlaceViewModel.swift
//  App
//
//  Created by Branimir Markovic on 18.12.21..
//

import Foundation


class PlaceViewModel {
    private var place: Place

    init(place: Place) {
        self.place = place
    }

    var tittle: String {
        "Domino"
    }

    var type: String {
        "Pizza"
    }

    var image: Data {
        Data()
    }

    func price() -> String {
          "$$"
    }

    func distance() -> String {
        "100m"
    }

    func rating() -> String {
        "3/5"
    }

    func description() -> String {
        ""
    }




}





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
        place.name
    }

    var type: String {
        guard let tag = place.tags.first else {return "Uknown"}
        return tag.tag.name
    }

    var image: Data {
        Data()
    }

    func price() -> String {
        guard let priceCount = place.price_tier,
            priceCount > 0 else {return "?"}
        var price: String = ""
        for _ in 1...priceCount {
            price += "$"
        }
        return price
    }

    func distance() -> String {
        "???m"
    }

    func rating() -> String {
        "\(place.score)/10"
    }

    func description() -> String {
        place.intro
    }




}





//
//  PlaceViewModel.swift
//  App
//
//  Created by Branimir Markovic on 18.12.21..
//

import Foundation
import UIKit


class PlaceViewModel {

    private var imageLoader: ImageLoader
    private var place: PointOfInterest

    var onImageLoad: ((Data) -> Void)?
    var onError: (()-> Void)?

    init(place: PointOfInterest,imageLoader: ImageLoader) {
        self.place = place
        self.imageLoader = imageLoader
    }

    func loadImage() {
        guard let urlString = place.imageURLs.first?.thumbnailURL,
        let url = URL(string: urlString) else {
            self.onError?()
            return}
        imageLoader.loadImage(url: url) { [weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let data):
                self.onImageLoad?(data)
            case .failure(_):
                self.onError?()
            }
        }
    }

    var tittle: String {
        place.name
    }

    var type: String {
        guard let tag = place.tags.first else {return "Unknown"}
        return tag.name
    }

    var image: Data {
        Data()
    }

    func price() -> String {
        guard let priceCount = place.priceTier,
            priceCount > 0 else {return ""}
        var price: String = ""
        for _ in 1...priceCount {
            price += "$"
        }
        return price
    }

    func distance() -> String {
        // TODO: - Handle distance
        "100m"
    }

    func rating() -> String {
        "\((place.score * 0.5).roundToDecimal(2))/5"
    }

    func description() -> String {
        place.intro
    }

    var longitude: Double {
        place.coordinates.longitude
    }

    var latitude: Double {
        place.coordinates.latitude
    }

    




}




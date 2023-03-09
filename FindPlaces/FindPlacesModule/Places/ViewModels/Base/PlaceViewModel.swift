//
//  PlaceViewModel.swift
//  App
//
//  Created by Branimir Markovic on 18.12.21..
//

import Foundation
import UIKit

public enum ImageLoadingQuality {
    case thumbnail
    case medium 
    case best
}

class PlaceViewModel {

    private var imageLoader: ImageLoader
    private var place: PointOfInterest

    var onImageLoad: ((Data) -> Void)?
    var onError: (()-> Void)?

    init(place: PointOfInterest,imageLoader: ImageLoader) {
        self.place = place
        self.imageLoader = imageLoader
    }

    func loadImage(quality: ImageLoadingQuality = .thumbnail) {
        var urlString: String? = nil
        switch quality {
        case .thumbnail:
            urlString = place.imageURLs.first?.thumbnailURL
        case .medium:
            urlString = place.imageURLs.first?.mediumURL
        case .best:
            urlString = place.imageURLs.first?.originalURL
        }
        guard let urlString = urlString,
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

    var title: String {
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





//
//  PlaceViewModel.swift
//  App
//
//  Created by Branimir Markovic on 18.12.21..
//

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
        guard false else {
            self.onError?()
            return}
        let url = URL(string: "")!
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
        return place.poiCategory?.localizedDisplayString() ?? ""
    }

    var image: Data {
        Data()
    }

    func distance() -> String {
        // TODO: - Handle distance
        "100m"
    }

    func description() -> String {
        "place.intro"
    }
    
    var coordinates:Coordinates {
        place.coordinates
    }
    
    var address: String? {
        place.adress
    }
    
    var contact: String? {
        place.phoneNumber
    }

    




}





//
//  PlaceDetailsComposer.swift
//  FindPlaces
//
//  Created by Branimir Markovic on 14.2.22..
//

import UIKit

class PlaceDetailsComposer {
    static func compose(imagesLoader: ImageLoader, notificationService: NotificationService, selectedPlace: PlaceViewModel) -> PlaceDetailsViewController {
        return PlaceDetailsViewController(viewModel:selectedPlace)
    }
}

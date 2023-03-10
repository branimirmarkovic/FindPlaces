//
//  MainPageComposer.swift
//  FindPlaces
//
//  Created by Branimir Markovic on 14.2.22..
//

import Foundation
import CoreLocation

class MainPageComposer {
    static func compose(
        pointOfInterestLoader: PointsOfInterestLoader,
        imageLoader: ImageLoader,
        poiCategoriesLoader: POICategoriesLoader,
        notificationService: NotificationService,
        layoutProvider: CollectionViewLayoutFactory,
        currentLocation: CLLocation) -> MainPageContainerViewController {
            let placesViewModel = PlacesViewModel(pointOfInterestsLoader: pointOfInterestLoader, imagesLoader: imageLoader)
            let poiCategoriesViewModel = POICategoriesViewModel(loader: poiCategoriesLoader)
            let compositeViewModel = MainPageCompositeViewModel(placesViewModel: placesViewModel, poiCategoriesViewModel: poiCategoriesViewModel, startingLocation: Coordinates(
                latitude: currentLocation.coordinate.latitude,
                longitude: currentLocation.coordinate.longitude))
            return MainPageContainerViewController(
                viewModel: compositeViewModel,
                notificationService: notificationService,
                layoutProvider: layoutProvider
            )
        }
    
}

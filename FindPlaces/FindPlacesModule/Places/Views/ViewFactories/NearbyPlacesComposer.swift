//
//  NearbyPlacesComposer.swift
//  FindPlaces
//
//  Created by Branimir Markovic on 14.2.22..
//

import UIKit
import CoreLocation

class NearbyPlacesComposer {
    static func compose(
        placesLoader: PointsOfInterestLoader,
        imagesLoader: ImageLoader,
        dataCachePolicy: DataCachePolicy,
        notificationService: NotificationService,
        layoutProvider: CollectionViewLayoutFactory,
        currentLocation: CLLocation,
        selectedTagViewModel: TagViewModel) -> PlacesByTagViewController {
            let viewModel = PlacesViewModel(loader: placesLoader, imagesLoader: imagesLoader, dataCachePolicy: dataCachePolicy)
            return PlacesByTagViewController(
                placesViewModel: viewModel,
                notificationService: notificationService,
                selectedTagViewModel: selectedTagViewModel,
                layoutProvider: layoutProvider,
                currentLocation: currentLocation)
        }
}

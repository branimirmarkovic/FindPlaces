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
        tagsLoader: TagsLoader,
        notificationService: NotificationService,
        dataCachePolicy: DataCachePolicy,
        layoutProvider: CollectionViewLayoutFactory,
        currentLocation: CLLocation) -> MainPageContainerViewController {
            let placesViewModel = PlacesViewModel(pointOfInterestsLoader: pointOfInterestLoader, imagesLoader: imageLoader, dataCachePolicy: dataCachePolicy)
            let tagsViewModel = TagsViewModel(loader: tagsLoader)
            let compositeViewModel = MainPageCompositeViewModel(placesViewModel: placesViewModel, tagsViewModel: tagsViewModel)
            return MainPageContainerViewController(
                viewModel: compositeViewModel,
                notificationService: notificationService,
                layoutProvider: layoutProvider,
                currentLocation: currentLocation
            )
        }
    
}

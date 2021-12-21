//
//  UIComposer.swift
//  App
//
//  Created by Branimir Markovic on 18.12.21..
//

import Foundation

typealias MainStore  = PlacesLoader & TagsLoader & ImageLoader

class UIComposer {

    static func mainPageViewController(store: MainStore, notificationService: NotificationService) -> MainPageViewController {
        MainPageViewController(placesViewModel: PlacesViewModel(loader: store, imagesLoader: store), tagsViewModel: TagsViewModel(loader: store), notificationService: notificationService)
    }

    static func placeDetailsViewController(viewModel: PlaceViewModel,notificationService: NotificationService) -> PlaceDetailsViewController {
        PlaceDetailsViewController(viewModel: viewModel)
    }

    static func nearbyPlacesViewController(viewModel: PlacesViewModel, notificationService: NotificationService, selectedTagViewModel: TagViewModel) -> NearbyPlacesViewController {
        NearbyPlacesViewController(placesViewModel: viewModel, notificationService: notificationService, selectedTagViewModel: selectedTagViewModel)
    }

}

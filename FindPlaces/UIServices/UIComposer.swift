//
//  UIComposer.swift
//  App
//
//  Created by Branimir Markovic on 18.12.21..
//

import Foundation



class UIComposer {

    static func mainPageViewController(store: MainStore, notificationService: NotificationService) -> MainPageViewController {
        let placesViewModel = PlacesViewModel(loader: store, imagesLoader: store)
        let tagsViewModel = TagsViewModel(loader: store)
        let compositeViewModel = MainPageCompositeViewModel(placesViewModel: placesViewModel, tagsViewModel: tagsViewModel)
        return MainPageViewController(viewModel: compositeViewModel, notificationService: notificationService)
    }

    static func placeDetailsViewController(viewModel: PlaceViewModel,notificationService: NotificationService) -> PlaceDetailsViewController {
        PlaceDetailsViewController(viewModel: viewModel)
    }

    static func nearbyPlacesViewController(viewModel: PlacesViewModel, notificationService: NotificationService, selectedTagViewModel: TagViewModel) -> NearbyPlacesViewController {
        NearbyPlacesViewController(placesViewModel: viewModel, notificationService: notificationService, selectedTagViewModel: selectedTagViewModel)
    }

}

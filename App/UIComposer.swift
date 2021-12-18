//
//  UIComposer.swift
//  App
//
//  Created by Branimir Markovic on 18.12.21..
//

import Foundation

typealias MainStore  = PlacesLoader & TagsLoader

class UIComposer {

    static func mainPageViewController(store: MainStore, notificationService: NotificationService) -> MainPageViewController {
        MainPageViewController(placesViewModel: PlacesViewModel(loader: store), tagsViewModel: TagsViewModel(loader: store), notificationService: notificationService)
    }

    static func placeDetailsViewController(viewModel: PlaceViewModel,notificationService: NotificationService) -> PlaceDetailsViewController {
        PlaceDetailsViewController(viewModel: viewModel)
    }

}

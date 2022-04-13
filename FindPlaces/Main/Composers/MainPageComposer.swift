//
//  MainPageComposer.swift
//  FindPlaces
//
//  Created by Branimir Markovic on 14.2.22..
//

import Foundation

class MainPageComposer {
    static func compose(
        store: MainStore,
        notificationService: NotificationService,
        dataCachePolicy: DataCachePolicy,
        layoutProvider: CollectionViewLayoutFactory) -> MainPageViewController {
            let placesViewModel = PlacesViewModel(loader: store, imagesLoader: store, dataCachePolicy: dataCachePolicy)
            let tagsViewModel = TagsViewModel(loader: store)
            let compositeViewModel = MainPageCompositeViewModel(placesViewModel: placesViewModel, tagsViewModel: tagsViewModel)
            return MainPageViewController(
                viewModel: compositeViewModel,
                notificationService: notificationService,
                layoutProvider: layoutProvider
            )
        }
    
}

//
//  MainCoordinator.swift
//  FindPlaces
//
//  Created by Branimir Markovic on 14.2.22..
//

import Foundation
import UIKit

class MainCoordinator {
    
    init(
        onRootControllerChangeHandler: @escaping (UIViewController) -> Void,
        mainPageControllerBuilder: @escaping () -> MainPageViewController,
        placeDetailsControllerBuilder: @escaping (PlaceViewModel) -> PlaceDetailsViewController,
        nearbyPlacesControllerBuilder: @escaping (TagViewModel) -> NearbyPlacesViewController
    ) {
        self.onRootControllerChangeHandler = onRootControllerChangeHandler
        self.mainPageControllerBuilder = mainPageControllerBuilder
        self.placeDetailsControllerBuilder = placeDetailsControllerBuilder
        self.nearbyPlacesControllerBuilder = nearbyPlacesControllerBuilder
    }
    
    private let onRootControllerChangeHandler: (UIViewController) -> Void
    private let mainPageControllerBuilder: () -> MainPageViewController
    private let placeDetailsControllerBuilder: (PlaceViewModel) -> PlaceDetailsViewController
    private let nearbyPlacesControllerBuilder: (TagViewModel) -> NearbyPlacesViewController
    
    
    public func present() {
        displayMainPageController()
    }
    
    func displayMainPageController() {
        let viewController = mainPageControllerBuilder()
        viewController.tagCellPressed = { tagViewModel in 
            self.displayNearbyPlacesController(for: tagViewModel)
        }
        onRootControllerChangeHandler(viewController)
    }
    
    func displayPlacesDetailsController(for placeViewModel: PlaceViewModel) {
        let viewController = placeDetailsControllerBuilder(placeViewModel)
        onRootControllerChangeHandler(viewController)
    }
    
    func displayNearbyPlacesController(for tagViewModel: TagViewModel) {
        let viewController = nearbyPlacesControllerBuilder(tagViewModel)
        onRootControllerChangeHandler(viewController)
    }
    
    
    
    
    
}

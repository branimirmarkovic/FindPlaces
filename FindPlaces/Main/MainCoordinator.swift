//
//  MainCoordinator.swift
//  FindPlaces
//
//  Created by Branimir Markovic on 14.2.22..
//

import Foundation
import UIKit

class MainCoordinator {
    
    private var mainWindow: UIWindow
    
    init(
        mainWindow: UIWindow,
        onRootControllerChangeHandler: @escaping (UIViewController) -> Void,
        mainPageControllerBuilder: @escaping () -> MainPageViewController,
        placeDetailsControllerBuilder: @escaping (PlaceViewModel) -> PlaceDetailsViewController,
        nearbyPlacesControllerBuilder: @escaping (TagViewModel) -> NearbyPlacesViewController
    ) {
        self.mainWindow = mainWindow
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
        let mainPageController = mainPageControllerBuilder()
        let navigationController = wrapInNavigationController(mainPageController)
        mainPageController.tagCellPressed = { tagViewModel in 
            let nearbyPlacesController = self.nearbyPlacesControllerBuilder(tagViewModel)
            navigationController.pushViewController(nearbyPlacesController, animated: true)
        }
        mainWindow.rootViewController = navigationController
    }
    
    func displayPlacesDetailsController(for placeViewModel: PlaceViewModel) {
        let viewController = placeDetailsControllerBuilder(placeViewModel)
        mainWindow.rootViewController = viewController
    }
    
    func displayNearbyPlacesController(for tagViewModel: TagViewModel) {
        let viewController = nearbyPlacesControllerBuilder(tagViewModel)
        mainWindow.rootViewController = viewController
    }
 
    // MARK: - Private Methods
    
    private func wrapInNavigationController(_ controller: UIViewController) -> UINavigationController {
        UINavigationController(rootViewController: controller)
    }
    
    private func presentModally(_ controller: UIViewController, from presenter: UIViewController, completion: (() -> Void)? = nil) {
        let navigationController = wrapInNavigationController(controller)
        presenter.present(navigationController, animated: true, completion: completion)
    }
    
}

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
        locationPermissionHandler: @escaping () -> Bool,
        askForPermissionHandler: @escaping(@escaping (Bool) -> Void) -> Void,
        onRootControllerChangeHandler: @escaping (UIViewController) -> Void,
        mainPageControllerBuilder: @escaping () -> MainPageViewController,
        placeDetailsControllerBuilder: @escaping (PlaceViewModel) -> PlaceDetailsViewController,
        nearbyPlacesControllerBuilder: @escaping (TagViewModel) -> NearbyPlacesViewController,
        errorControllerBuilder: @escaping () -> ErrorViewController
    ) {
        self.mainWindow = mainWindow
        self.onRootControllerChangeHandler = onRootControllerChangeHandler
        self.mainPageControllerBuilder = mainPageControllerBuilder
        self.placeDetailsControllerBuilder = placeDetailsControllerBuilder
        self.nearbyPlacesControllerBuilder = nearbyPlacesControllerBuilder
        self.isLocationPermitted = locationPermissionHandler
        self.askForPermissionHandler = askForPermissionHandler
        self.errorControllerBuilder = errorControllerBuilder
        
    }
    
    private let askForPermissionHandler: (@escaping (Bool) -> Void) -> Void
    private let isLocationPermitted: () -> Bool
    private let onRootControllerChangeHandler: (UIViewController) -> Void
    private let mainPageControllerBuilder: () -> MainPageViewController
    private let placeDetailsControllerBuilder: (PlaceViewModel) -> PlaceDetailsViewController
    private let nearbyPlacesControllerBuilder: (TagViewModel) -> NearbyPlacesViewController
    private let errorControllerBuilder: () -> ErrorViewController
    
    
    public func present() {
        displayErrorViewController()
        if isLocationPermitted() {
            displayMainPageController()
        } else {
            askForPermissionHandler() { success in 
                if success {
                    self.displayMainPageController()
                } else {
                    self.displayErrorViewController()
                }
            }
        }
    }
    
    func displayBlancPage() {
        let viewController = UIViewController()
        mainWindow.rootViewController = viewController
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
    
    func displayErrorViewController() {
        let viewController = errorControllerBuilder()
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

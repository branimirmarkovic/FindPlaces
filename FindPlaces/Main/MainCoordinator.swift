//
//  MainCoordinator.swift
//  FindPlaces
//
//  Created by Branimir Markovic on 14.2.22..
//

import Foundation
import UIKit
import CoreLocation



typealias IsLocationPermittedHandler = () -> Bool
typealias LocationPermissionCompletion = (@escaping (Bool) -> Void) -> Void
typealias CurrentLocationHandler = (_ completion: @escaping (LocationResult) -> Void) -> Void

typealias RootControllerChangeHandler = (UIViewController) -> Void

typealias MainPageControllerBuilder = (CLLocation) -> MainPageViewController
typealias PlaceDetailsControllerBuilder = (PlaceViewModel) -> PlaceDetailsViewController
typealias PlacesForTagControllerBuilder = (TagViewModel) -> NearbyPlacesViewController
typealias ErrorControllerBuilder = () -> ErrorViewController


class MainCoordinator {
    
    private var mainWindow: UIWindow
    
    init(
        mainWindow: UIWindow,
        locationPermissionHandler: @escaping IsLocationPermittedHandler,
        askForPermissionHandler: @escaping LocationPermissionCompletion,
        currentLocationGetter: @escaping CurrentLocationHandler,
        onRootControllerChangeHandler: @escaping RootControllerChangeHandler,
        mainPageControllerBuilder: @escaping MainPageControllerBuilder,
        placeDetailsControllerBuilder: @escaping PlaceDetailsControllerBuilder,
        nearbyPlacesControllerBuilder: @escaping PlacesForTagControllerBuilder,
        errorControllerBuilder: @escaping ErrorControllerBuilder
    ) {
        self.mainWindow = mainWindow
        self.onRootControllerChangeHandler = onRootControllerChangeHandler
        self.mainPageControllerBuilder = mainPageControllerBuilder
        self.placeDetailsControllerBuilder = placeDetailsControllerBuilder
        self.nearbyPlacesControllerBuilder = nearbyPlacesControllerBuilder
        self.isLocationPermitted = locationPermissionHandler
        self.askForPermissionHandler = askForPermissionHandler
        self.errorControllerBuilder = errorControllerBuilder
        self.currentLocationGetter = currentLocationGetter
        
    }
    private let currentLocationGetter: (@escaping(Result<CLLocation, Error>) -> Void) -> Void
    private let askForPermissionHandler: (@escaping (Bool) -> Void) -> Void
    private let isLocationPermitted: () -> Bool
    private let onRootControllerChangeHandler: (UIViewController) -> Void
    private let mainPageControllerBuilder: MainPageControllerBuilder
    private let placeDetailsControllerBuilder: (PlaceViewModel) -> PlaceDetailsViewController
    private let nearbyPlacesControllerBuilder: (TagViewModel) -> NearbyPlacesViewController
    private let errorControllerBuilder: () -> ErrorViewController
    
    
    public func present() {
        displayErrorViewController()
        if isLocationPermitted() {
            displayMainPageController { result in
                switch result {
                case .success(()):
                    ()
                case .failure(_):
                    self.displayErrorViewController()
                }
            }
        } else {
            askForPermissionHandler() { success in 
                if success {
                    self.displayMainPageController { result in
                        switch result {
                        case .success(()):
                            ()
                        case .failure(_):
                            self.displayErrorViewController()
                        }
                    }
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
    
    func displayMainPageController(completion: @escaping (Result<Void, Error>) -> Void) {
        currentLocationGetter() { result in
            switch result {
            case.success(let location):
                let mainPageController = self.mainPageControllerBuilder(location)
                let navigationController = self.wrapInNavigationController(mainPageController)
                mainPageController.tagCellPressed = { tagViewModel in 
                    let nearbyPlacesController = self.nearbyPlacesControllerBuilder(tagViewModel)
                    navigationController.pushViewController(nearbyPlacesController, animated: true)
                }
                self.mainWindow.rootViewController = navigationController
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
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

//
//  MainCoordinator.swift
//  FindPlaces
//
//  Created by Branimir Markovic on 14.2.22..
//

import Foundation
import UIKit
import CoreLocation



typealias IsLocationPermittedHandler = () -> LocationAuthorizationStatus
typealias LocationPermissionCompletion = (@escaping (LocationAuthorizationStatus) -> Void) -> Void
typealias CurrentLocationHandler = (_ completion: @escaping (LocationResult) -> Void) -> Void

typealias RootControllerChangeHandler = (UIViewController) -> Void

typealias MainPageControllerBuilder = (CLLocation) -> MainPageContainerViewController
typealias PlaceDetailsControllerBuilder = (PlaceViewModel) -> PlaceDetailsViewController
typealias PlacesForTagControllerBuilder = (CLLocation,TagViewModel) -> PlacesByTagViewController
typealias ErrorControllerBuilder = (String?, String?, (() -> Void)?) -> ErrorViewController


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
    private let currentLocationGetter: CurrentLocationHandler
    private let askForPermissionHandler: LocationPermissionCompletion
    private let isLocationPermitted: IsLocationPermittedHandler
    private let onRootControllerChangeHandler: RootControllerChangeHandler
    private let mainPageControllerBuilder: MainPageControllerBuilder
    private let placeDetailsControllerBuilder: PlaceDetailsControllerBuilder
    private let nearbyPlacesControllerBuilder: PlacesForTagControllerBuilder
    private let errorControllerBuilder: ErrorControllerBuilder
    
    
    public func present() {
        displayBlancPage()
        switch isLocationPermitted() {
        case .allowed:
                displayMainPageController { result in
                    switch result {
                    case .success(()):
                        ()
                    case .failure(_):
                        self.displayErrorViewController(
                            with: "Cannot retrieve location, please try again.",
                            buttonTittle: nil,
                            buttonAction: nil)
                    }
                }
        case .notDetermined:
            askForPermissionHandler() { newStatus in
                switch newStatus {
                case .allowed:
                    self.displayMainPageController { result in
                        switch result {
                        case .success(()):
                            ()
                        case .failure(_):
                            self.displayErrorViewController(
                                with: "Cannot retrieve location, please try again.", 
                                buttonTittle: nil,
                                buttonAction: nil)
                        }
                    }
                case .notDetermined:
                    
                    break
                case .denied:
                    self.displayErrorViewController(
                        with: "Please provide location permission",
                        buttonTittle: "Open Settings",
                        buttonAction: { 
                            self.askForPermissionHandler() { success in 
                                self.displaySettingsAppOpenAlert()
                            }
                        })
                }
 
            }
        case .denied:
            self.displayErrorViewController(
                with: "Please provide location permission",
                buttonTittle: "Open Settings",
                buttonAction: { 
                    self.askForPermissionHandler() { success in 
                        self.displaySettingsAppOpenAlert()
                    }
                })
        }
    }
    
    func displayBlancPage() {
        let viewController = WelcomePageViewController(nibName: nil, bundle: nil)
        mainWindow.rootViewController = viewController
    }
    
    func displayMainPageController(completion: @escaping (Result<Void, Error>) -> Void) {
        currentLocationGetter() { result in
            switch result {
            case.success(let location):
                let mainPageController = self.mainPageControllerBuilder(location)
                let navigationController = self.wrapInNavigationController(mainPageController)
                mainPageController.tagCellPressed = { tagViewModel in 
                    self.currentLocationGetter() { result in 
                        switch result {
                            
                        case .success(let location):
                            let nearbyPlacesController = self.nearbyPlacesControllerBuilder(location, tagViewModel)
                            navigationController.pushViewController(nearbyPlacesController, animated: true)
                        case .failure(_):
                            ()
                        }
                    }
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
//        let viewController = nearbyPlacesControllerBuilder(tagViewModel)
//        mainWindow.rootViewController = viewController
    }
    
    func displayErrorViewController(with message: String?, buttonTittle: String?, buttonAction: (() -> Void)?) {
        let viewController = errorControllerBuilder(message, buttonTittle, buttonAction)
        mainWindow.rootViewController = viewController
    }
    
    func displaySettingsAppOpenAlert() {
        let alert = alertToSettingsAppBuilder()
        mainWindow.rootViewController?.present(alert, animated: true)
    }
    
    private func alertToSettingsAppBuilder() -> UIAlertController {
        let alertController = UIAlertController (title: "Location Access", message: "Please provide location access \n Privacy -> Location Service", preferredStyle: .alert)

            let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in

                
                guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                    return
                }

                if UIApplication.shared.canOpenURL(settingsUrl) {
                    UIApplication.shared.open(settingsUrl)
                }
            }
            alertController.addAction(settingsAction)
            let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
            alertController.addAction(cancelAction)

            return alertController
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

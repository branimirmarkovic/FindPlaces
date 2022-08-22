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
        errorControllerBuilder: @escaping ErrorControllerBuilder,
        collectionViewLayoutProvider: CollectionViewLayoutFactory
    ) {
        self.mainWindow = mainWindow
        self.onRootControllerChangeHandler = onRootControllerChangeHandler
        self.mainPageControllerBuilder = mainPageControllerBuilder
        self.placeDetailsControllerBuilder = placeDetailsControllerBuilder
        self.isLocationPermitted = locationPermissionHandler
        self.askForPermissionHandler = askForPermissionHandler
        self.errorControllerBuilder = errorControllerBuilder
        self.currentLocationGetter = currentLocationGetter
        self.collectionViewLayoutProvider = collectionViewLayoutProvider
        
    }
    private let currentLocationGetter: CurrentLocationHandler
    private let askForPermissionHandler: LocationPermissionCompletion
    private let isLocationPermitted: IsLocationPermittedHandler
    private let onRootControllerChangeHandler: RootControllerChangeHandler
    private let mainPageControllerBuilder: MainPageControllerBuilder
    private let placeDetailsControllerBuilder: PlaceDetailsControllerBuilder
    private let errorControllerBuilder: ErrorControllerBuilder
    private let collectionViewLayoutProvider: CollectionViewLayoutFactory
    
    
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
                mainPageController.singlePLaceControllerPresentationHandler = {[weak mainPageController] placeViewModel in 
                    guard let mainPageController = mainPageController else {return}
                    self.displayPlacesDetailsController(for: placeViewModel, on: mainPageController)
                }
                let navigationController = self.wrapInNavigationController(mainPageController)
                self.mainWindow.rootViewController = navigationController
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func displayPlacesDetailsController(for placeViewModel: PlaceViewModel, on parentController: UIViewController) {
        let viewController = placeDetailsControllerBuilder(placeViewModel)
        if let sheet = viewController.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.largestUndimmedDetentIdentifier = .medium
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.prefersEdgeAttachedInCompactHeight = true
            sheet.prefersGrabberVisible = true
        }
        parentController.present(viewController, animated: true)
    }
    
    func displayPlacesListController(on parentController: UIViewController & UICollectionViewDelegate & UICollectionViewDataSource, startingHandler: () -> Void) {
        let collectionView = PlacesCollectionViewController(collectionViewLayout: collectionViewLayoutProvider.doubleSectionLayout())
        collectionView.collectionView.dataSource = parentController
        collectionView.collectionView.delegate = parentController
        collectionView.collectionView.register(TagCollectionViewCell.self, forCellWithReuseIdentifier: TagCollectionViewCell.identifier)
        collectionView.collectionView.register(PlaceCollectionViewCell.self, forCellWithReuseIdentifier: PlaceCollectionViewCell.identifier)
        collectionView.collectionView.backgroundColor = .white
        if let sheet = collectionView.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.largestUndimmedDetentIdentifier = .medium
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.prefersEdgeAttachedInCompactHeight = true
            sheet.prefersGrabberVisible = true
        }
        startingHandler()
        parentController.present(collectionView, animated: true, completion: {})
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

//
//  SceneDelegate.swift
//  App
//
//  Created by Branimir Markovic on 17.12.21..
//

import UIKit
import CoreLocation

typealias MainStore  = PlacesLoader & TagsLoader & ImageLoader

fileprivate final class Dependencies {
    
    
    let client: HTTPClient  
    let locationPolicy: LocationPolicy 
    let locationManager: LocationManager 
    let mainStore: MainStore
    let notificationService: NotificationService
    let cachePolicy: DataCachePolicy
    let collectionViewLayoutProvider: CollectionViewLayoutFactory
    let permissionManager: PermissionManager
    
    private let systemLocationManager: CLLocationManager 
    
    init () {
        systemLocationManager = CLLocationManager()
        client = DefaultHTTPClient(basePath: TriposoPathProvider.main.basePath)
        locationPolicy = DefaultLocationPolicy()
        locationManager = SystemLocationManagerDecorator(locationPolicy: locationPolicy, locationManager: systemLocationManager)
        mainStore =  TriposoService(client: client, locationManager: locationManager)
        notificationService = DefaultNotificationService()
        cachePolicy = DefaultCachePolicy(.oneMinute)
        collectionViewLayoutProvider = DefaultCollectionViewLayoutProvider()
        permissionManager = DefaultPermissionManager(locationManager: systemLocationManager)
    }
    
} 

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    fileprivate let dependencies = Dependencies()
    var window: UIWindow?
    var coordinator: MainCoordinator?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(frame: windowScene.screen.bounds)
        self.window = window
        configureWindow(window, with: windowScene)
        window.makeKeyAndVisible()
        
        let coordinator = MainCoordinator(
            mainWindow: window,
            locationPermissionHandler: {
                self.dependencies.permissionManager.isLocationPermitted()
            }, askForPermissionHandler: { completion in
                self.dependencies.permissionManager.askLocationPermission(completion: completion)
            }, currentLocationGetter: { completion in
                self.dependencies.locationManager.currentLocation(completion: completion)
            },
            onRootControllerChangeHandler: { viewController in
                self.rootControllerDidChange(viewController)  
            },
            mainPageControllerBuilder: { currentLocation in 
                MainPageComposer.compose(
                    store: self.dependencies.mainStore,
                    notificationService: self.dependencies.notificationService,
                    dataCachePolicy: self.dependencies.cachePolicy,
                    layoutProvider: self.dependencies.collectionViewLayoutProvider,
                    currentLocation: currentLocation)
            },
            placeDetailsControllerBuilder: { selectedPlace in
                PlaceDetailsComposer.compose(
                    imagesLoader: self.dependencies.mainStore,
                    notificationService: self.dependencies.notificationService, 
                    selectedPlace: selectedPlace)
            },
            nearbyPlacesControllerBuilder: {  selectedTag in
                NearbyPlacesComposer.compose(
                    placesLoader: self.dependencies.mainStore,
                    imagesLoader: self.dependencies.mainStore,
                    dataCachePolicy: self.dependencies.cachePolicy,
                    notificationService: self.dependencies.notificationService,
                    layoutProvider: self.dependencies.collectionViewLayoutProvider,
                    selectedTagViewModel: selectedTag)
            }, 
            errorControllerBuilder: {
                ErrorViewController(nibName: nil, bundle: nil)
            }
        )
        self.coordinator = coordinator
        coordinator.present()
    }

    func sceneDidDisconnect(_ scene: UIScene) {}

    func sceneDidBecomeActive(_ scene: UIScene) {}

    func sceneWillResignActive(_ scene: UIScene) {}

    func sceneWillEnterForeground(_ scene: UIScene) {}

    func sceneDidEnterBackground(_ scene: UIScene) {}
    
    private func rootControllerDidChange(_ rootController: UIViewController) {
        window?.rootViewController = rootController
    }
    
    private func configureWindow(_ window: UIWindow, with scene: UIWindowScene) {
        window.canResizeToFitContent = true
        window.windowScene = scene
    }


}


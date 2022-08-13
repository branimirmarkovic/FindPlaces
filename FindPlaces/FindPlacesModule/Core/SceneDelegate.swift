//
//  SceneDelegate.swift
//  App
//
//  Created by Branimir Markovic on 17.12.21..
//

import UIKit
import CoreLocation

fileprivate final class Dependencies {
    
    
    let client: HTTPClient  
    let locationPolicy: LocationPolicy 
    let locationManager: LocationManager 
    let pointOfInterestLoader: PointsOfInterestLoader
    let imagesLoader: ImageLoader
    let tagsLoader: TagsLoader
    let locationsLoader: TriposoLocationsLoader
    let notificationService: NotificationService
    let cachePolicy: DataCachePolicy
    let collectionViewLayoutProvider: CollectionViewLayoutFactory
    let permissionManager: PermissionManager
    
    private let systemLocationManager: CLLocationManager 
    
    init () {
        systemLocationManager = CLLocationManager()
        client = DefaultHTTPClient(basePath: AuthorizationCenter.triposoBasePath)
        locationPolicy = DefaultLocationPolicy()
        locationManager = SystemLocationManagerDecorator(locationPolicy: locationPolicy, locationManager: systemLocationManager)
        locationsLoader = RemoteLocationsLoader(client: client)
        tagsLoader = RemoteTagLoader(client: client, locationManager: locationManager, triposloLocationsLoader: locationsLoader)
        imagesLoader = RemoteImageLoader(client: client)
        pointOfInterestLoader = RemotePointsOfInterestLoader(client: client, locationManager: locationManager)
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
                    pointOfInterestLoader: self.dependencies.pointOfInterestLoader,
                    imageLoader: self.dependencies.imagesLoader,
                    tagsLoader: self.dependencies.tagsLoader,
                    notificationService: self.dependencies.notificationService,
                    dataCachePolicy: self.dependencies.cachePolicy,
                    layoutProvider: self.dependencies.collectionViewLayoutProvider,
                    currentLocation: currentLocation)
            },
            placeDetailsControllerBuilder: { selectedPlace in
                PlaceDetailsComposer.compose(
                    imagesLoader: self.dependencies.imagesLoader,
                    notificationService: self.dependencies.notificationService, 
                    selectedPlace: selectedPlace)
            },
            nearbyPlacesControllerBuilder: {  currentLocation, selectedTag in
                NearbyPlacesComposer.compose(
                    pointOfInterestLoader: self.dependencies.pointOfInterestLoader,
                    imagesLoader: self.dependencies.imagesLoader,
                    dataCachePolicy: self.dependencies.cachePolicy,
                    notificationService: self.dependencies.notificationService,
                    layoutProvider: self.dependencies.collectionViewLayoutProvider,
                    currentLocation: currentLocation,
                    selectedTagViewModel: selectedTag)
            }, 
            errorControllerBuilder: { message, buttonTittle , buttonAction in 
                ErrorViewController(message: message, buttonTittle: buttonTittle, buttonTappedAction: buttonAction)
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


//
//  SceneDelegate.swift
//  App
//
//  Created by Branimir Markovic on 17.12.21..
//

import UIKit

typealias MainStore  = PlacesLoader & TagsLoader & ImageLoader

fileprivate final class Dependencies {
    static func client() -> HTTPClient {
        DefaultHTTPClient(basePath: TriposoPathProvider.main.basePath)
    }
    static func locationPolicy() -> LocationPolicy {
        DefaultLocationPolicy()
    }
    static func locationManager() -> LocationManager {
        DefaultLocationManager(locationPolicy: locationPolicy())
    }
    static func mainStore() ->  MainStore {
        TriposoService(client: client(), locationManager: locationManager())
    }
    
    static func notificationService() -> NotificationService {
        DefaultNotificationService()
    }
    
    static func cachePolicy() -> DataCachePolicy {
        DefaultCachePolicy(.fiveMinutes)
    }
    
    static func collectionViewLayoutProvider() -> CollectionViewLayoutFactory {
        DefaultCollectionViewLayoutProvider()
    }
    
} 

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var coordinator: MainCoordinator?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(frame: windowScene.screen.bounds)
        self.window = window
        configureWindow(window, with: windowScene)
        window.makeKeyAndVisible()
        
       let coordinator = MainCoordinator(
            onRootControllerChangeHandler: { viewController in
                self.rootControllerDidChange(viewController)  
            },
            mainPageControllerBuilder: { 
                MainPageComposer.compose(
                    store: Dependencies.mainStore(),
                    notificationService: Dependencies.notificationService(),
                    dataCachePolicy: Dependencies.cachePolicy(),
                    layoutProvider: Dependencies.collectionViewLayoutProvider())
            },
            placeDetailsControllerBuilder: { selectedPlace in
                PlaceDetailsComposer.compose(
                    imagesLoader: Dependencies.mainStore(),
                    notificationService: Dependencies.notificationService(), 
                    selectedPlace: selectedPlace)
            },
            nearbyPlacesControllerBuilder: {  selectedTag in
                NearbyPlacesComposer.compose(
                    placesLoader: Dependencies.mainStore(),
                    imagesLoader: Dependencies.mainStore(),
                    dataCachePolicy: Dependencies.cachePolicy(),
                    notificationService: Dependencies.notificationService(),
                    layoutProvider: Dependencies.collectionViewLayoutProvider(),
                    selectedTagViewModel: selectedTag)
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


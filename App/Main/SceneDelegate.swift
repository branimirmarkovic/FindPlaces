//
//  SceneDelegate.swift
//  App
//
//  Created by Branimir Markovic on 17.12.21..
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    lazy var locationManager: LocationManager =  {
        DefaultLocationManager(locationPolicy: DefaultLocationPolicy())
    }()


    lazy var mainStore: MainStore = {
        TriposoService(client: DefaultHTTPClient(basePath: TriposoPaths.Base.path), locationManager: locationManager)
//        AlwaysFailingStore()
    }()

    lazy var notificationService: NotificationService = {
        DefaultNotificationService()
    }()


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
         window = UIWindow(windowScene: windowScene)

        let rootViewController = UIComposer.mainPageViewController(store: mainStore, notificationService: notificationService)

        let navigationController = UINavigationController(rootViewController: rootViewController)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {}

    func sceneDidBecomeActive(_ scene: UIScene) {}

    func sceneWillResignActive(_ scene: UIScene) {}

    func sceneWillEnterForeground(_ scene: UIScene) {}

    func sceneDidEnterBackground(_ scene: UIScene) {}


}


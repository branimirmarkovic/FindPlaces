//
//  CompositionRoot.swift
//  App
//
//  Created by Branimir Markovic on 12.1.22..
//

import Foundation

typealias MainStore  = PlacesLoader & TagsLoader & ImageLoader

class CompositionRoot {

    static func locationManager() -> LocationManager {
        let locationPolicy = DefaultLocationPolicy()
        return DefaultLocationManager(locationPolicy: locationPolicy)
    }

    static func client() -> HTTPClient {
        DefaultHTTPClient(basePath: TriposoPathProvider.main.basePath)
    }
    static func notificationService() -> NotificationService {
        DefaultNotificationService()
    }

    static func mainStore() -> MainStore {
        TriposoService(client: client(), locationManager: locationManager())
//        AlwaysFailingStore()
    }


}

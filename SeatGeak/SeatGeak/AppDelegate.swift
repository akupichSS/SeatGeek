//
//  AppDelegate.swift
//  SeatGeak
//
//  Created by Andriy Kupich on 5/6/19.
//  Copyright © 2019 Andriy Kupich. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let apiClient = APIClient()
        let storage = EventsStorage()
        let sceneCoordinator = SceneCoordinator(window: window!)
        
        let eventsViewModel = EventsViewModel(apiClient: apiClient, storage: storage, coordinator:
            sceneCoordinator)
        let firstScene = Scene.events(eventsViewModel)
        sceneCoordinator.transition(to: firstScene, type: .root)
        
        return true
    }
}


//
//  AppDelegate.swift
//  GarageFinder
//
//  Created by João Pedro Aragão on 19/08/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//        CoreDataManager.shared.deleteAll(Favorite.self)
//        CoreDataManager.shared.deleteAll(Identifier.self)
        window = UIWindow(frame: UIScreen.main.bounds)
        let mapViewController = MapViewController()
        //let navigationController = UINavigationController(rootViewController: mapViewController)
        window?.rootViewController = mapViewController
        window?.makeKeyAndVisible()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        
    }

    func applicationWillTerminate(_ application: UIApplication) {
        CoreDataManager.shared.saveChanges()
    }

}

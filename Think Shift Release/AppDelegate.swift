//
//  AppDelegate.swift
//  Think Shift Release
//
//  Created by Philip Dow on 7/11/17.
//  Copyright © 2017 Zilliance. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let sideMenuViewController = CustomSideViewController()
        sideMenuViewController.setupHome()

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = sideMenuViewController
        window?.makeKeyAndVisible()
        
        return true
    }

}


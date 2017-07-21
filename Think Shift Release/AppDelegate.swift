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
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = UIStoryboard(name: "HomeViewController", bundle: nil).instantiateInitialViewController()
        window?.makeKeyAndVisible()
        
        return true
    }

}


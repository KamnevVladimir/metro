//
//  AppDelegate.swift
//  MetroTwitter
//
//  Created by Tsar on 14.04.2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Creating initial VC
        let twitterViewController = TwitterViewController()
        let twitterNavigationController = UINavigationController(rootViewController: twitterViewController)
        twitterNavigationController.navigationBar.prefersLargeTitles = true
        // Init and configure window
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = twitterNavigationController
        window?.makeKeyAndVisible()
        
        return true
    }


}


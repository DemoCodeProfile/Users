//
//  AppDelegate.swift
//  users
//
//  Copyright © 2019 Вадим. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setupNavigationAppereance()
        return true
    }
    
    private func setupNavigationAppereance() {
        UINavigationBar.appearance().barTintColor = Theme.colors.background
        UINavigationBar.appearance().tintColor = Theme.colors.main
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor : Theme.colors.main]
    }
}


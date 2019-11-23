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
        DependencyInjection.instance.container.registerServices()
        window = UIWindow(frame: UIScreen.main.bounds)
        let configUserList = UserListConfiguration()
        let navigationController = UINavigationController(rootViewController: configUserList.viewController ?? UIViewController())
        navigationController.navigationBar.isTranslucent = false
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        configUserList.configureStart(input: UserListConfiguration.Input(transition: .none))
        return true
    }
    
    private func setupNavigationAppereance() {
        UINavigationBar.appearance().barTintColor = Theme.colors.background
        UINavigationBar.appearance().tintColor = Theme.colors.main
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor : Theme.colors.main]
    }
}


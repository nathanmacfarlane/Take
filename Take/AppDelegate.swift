//
//  AppDelegate.swift
//  Take
//
//  Created by Family on 4/26/18.
//  Copyright © 2018 N8. All rights reserved.
//

import Firebase
import UIKit
//import GoogleSignIn

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate/*, GIDSignInDelegate*/ {

    var window: UIWindow?
    var initialViewController: UIViewController?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()

        self.window = UIWindow(frame: UIScreen.main.bounds)
        let nav1 = UINavigationController()
        nav1.navigationBar.barTintColor = UIColor(named: "BluePrimaryDark")
        nav1.navigationBar.tintColor = UIColor(named: "PinkAccent")
        nav1.navigationBar.isTranslucent = false
        let mainView = SearchRoutesVC()
        nav1.viewControllers = [mainView]
        self.window?.rootViewController = nav1
        self.window?.makeKeyAndVisible()

        return true
    }

}

//
//  AppDelegate.swift
//  ChitChat02
//
//  Created by Timun on 13.09.2020.
//  Copyright © 2020 TimunInc. All rights reserved.
//

import UIKit
import Firebase

let APP_LOG_ENABLED = true

func applog(_ message: String) {
    if APP_LOG_ENABLED {
        print(message)
    }
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    private let rootAssembly = RootAssembly()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let channels = rootAssembly.presentationAssembly.channelsViewController()
        let navController = rootAssembly.presentationAssembly.navigationViewController(withRoot: channels)
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
        
        let prefs = UserDefaults.standard
        if (prefs.integer(forKey: ThemeManager.key) as Int?) == nil {
            prefs.set(Theme.classic.rawValue, forKey: ThemeManager.key)
        }

//        if let uuid = prefs.string(forKey: UserData.keyUUID) as String? {
//            Log.prefs("existing uuid = \(uuid)")
//        } else {
//            let uuid = UUID().uuidString
//            Log.prefs("new uuid = \(uuid)")
//            prefs.set(uuid, forKey: UserData.keyUUID)
//        }
        
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
    }
}

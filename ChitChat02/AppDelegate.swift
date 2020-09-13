//
//  AppDelegate.swift
//  ChitChat02
//
//  Created by Timun on 13.09.2020.
//  Copyright © 2020 TimunInc. All rights reserved.
//

import UIKit

let DEBUG_ENABLED = true

func applog(_ message: String) {
    if DEBUG_ENABLED {
        print(message)
    }
}

private enum AppState {
    case NotRunning
    case Inactive
    case Active
    case Background
    case Terminated
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    private var currentState: AppState = .NotRunning
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        applog("Application moved from '\(currentState)' to '\(AppState.Inactive)': \(#function)")
        currentState = .Inactive
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        applog("Application moved from '\(currentState)' to '\(AppState.Active)': \(#function)")
        currentState = .Active
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        applog("Application moved from '\(currentState)' to '\(AppState.Inactive)': \(#function)")
        currentState = .Inactive
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        applog("Application moved from '\(currentState)' to '\(AppState.Background)': \(#function)")
        currentState = .Background
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        applog("Application moved from '\(currentState)' to '\(AppState.Terminated)': \(#function)")
        // no need to assign currentState because we are going to be terminated
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        applog("Application moved from '\(currentState)' to '\(AppState.Inactive)': \(#function)")
        currentState = .Inactive
    }
    
    // MARK: UISceneSession Lifecycle
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}


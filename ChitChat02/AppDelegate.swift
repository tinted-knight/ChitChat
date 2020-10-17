//
//  AppDelegate.swift
//  ChitChat02
//
//  Created by Timun on 13.09.2020.
//  Copyright © 2020 TimunInc. All rights reserved.
//

import UIKit

let LYFECYCLE_LOG_ENABLED = false
let APP_LOG_ENABLED = true

func lifecycleLogs(_ message: String) {
    if LYFECYCLE_LOG_ENABLED {
        print(message)
    }
}

func applog(_ message: String) {
    if APP_LOG_ENABLED {
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
        lifecycleLogs("Application moved from '\(currentState)' to '\(AppState.Inactive)': \(#function)")
        currentState = .Inactive
        
        let prefs = UserDefaults.standard
        if (prefs.integer(forKey: ThemeManager.key) as Int?) == nil {
            prefs.set(Theme.classic.rawValue, forKey: ThemeManager.key)
        }
        
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        lifecycleLogs("Application moved from '\(currentState)' to '\(AppState.Active)': \(#function)")
        currentState = .Active
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        lifecycleLogs("Application moved from '\(currentState)' to '\(AppState.Inactive)': \(#function)")
        currentState = .Inactive
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        lifecycleLogs("Application moved from '\(currentState)' to '\(AppState.Background)': \(#function)")
        currentState = .Background
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        lifecycleLogs("Application moved from '\(currentState)' to '\(AppState.Terminated)': \(#function)")
        // no need to assign currentState because we are going to be terminated
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        lifecycleLogs("Application moved from '\(currentState)' to '\(AppState.Inactive)': \(#function)")
        currentState = .Inactive
    }
}

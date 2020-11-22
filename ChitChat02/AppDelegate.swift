//
//  AppDelegate.swift
//  ChitChat02
//
//  Created by Timun on 13.09.2020.
//  Copyright © 2020 TimunInc. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UIGestureRecognizerDelegate {
    
    var window: UIWindow?
    
    private let rootAssembly = RootAssembly()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        
        self.window = CustomUIWindow(frame: UIScreen.main.bounds)
        let channels = rootAssembly.presentationAssembly.channelsViewController()
        let navController = rootAssembly.presentationAssembly.navigationViewController(withRoot: channels)
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
//        let tap = UIGestureRecognizer(target: self, action:nil)
//        tap.delegate = self
//        window?.addGestureRecognizer(tap)
        
        return true
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive event: UIEvent) -> Bool {
        print("event")
        let state = gestureRecognizer.state
        if let root = window?.rootViewController as? UINavigationController,
            let visible = root.visibleViewController as? FunController,
            let touch = event.allTouches?.first {
            switch state {
            case .began:
                print("began")
            case .possible:
                print("possible")
            case .changed:
                print("changed")
            case .ended:
                print("ended")
            case .cancelled:
                print("cancelled")
            case .failed:
                print("failed")
            }
        }
        return false
    }
    
//    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
//        print("app touch, \(String(describing: touch.phase))")
////        if let root = window?.rootViewController as? UINavigationController,
////            let visible = root.visibleViewController as? FunController {
////            if gestureRecognizer.state == .ended || gestureRecognizer.state == .cancelled || gestureRecognizer.state == .failed {
////                print("ended")
////                visible.endFun()
////            } else {
////                print("not ended")
////                let position = touch.location(in: window)
////                visible.startFun(at: position)
////            }
////        }
//        return false
//    }
    
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

class CustomUIWindow: UIWindow {
    override func sendEvent(_ event: UIEvent) {
        super.sendEvent(event)
        
        switch event.type {
        case .hover:
            print("hover")
        case .touches:
            print("touches")
            if let touch = event.touches(for: self)?.first {
                switch touch.phase {
                case .began:
                    print("     began")
                    NotificationCenter.default.post(name: Notification.Name("TouchPhaseBeganCustomNotification"), object: event)
                case .moved:
                    print("     moved")
                    NotificationCenter.default.post(name: Notification.Name("TouchPhaseMovedCustomNotification"), object: event)
                case .stationary:
                    print("     stationary")
                case .ended:
                    print("     ended")
                    NotificationCenter.default.post(name: Notification.Name("TouchPhaseEndedCustomNotification"), object: event)
                case .cancelled:
                    print("     cancelled")
                    NotificationCenter.default.post(name: Notification.Name("TouchPhaseEndedCustomNotification"), object: event)
                case .regionEntered:
                    print("     regionended")
                case .regionMoved:
                    print("     regionmoved")
                case .regionExited:
                    print("     regionexited")
                @unknown default:
                    print("     default")
                    NotificationCenter.default.post(name: Notification.Name("TouchPhaseEndedCustomNotification"), object: event)
                }
            }
        case .motion:
            print("motion")
        case .remoteControl:
            print("remote")
        case .presses:
            print("presses")
        case .scroll:
            print("scroll")
        case .transform:
            print("transform")
        @unknown default:
            print("default")
        }
    }
}

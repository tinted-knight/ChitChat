//
//  Log.swift
//  ChitChat02
//
//  Created by Timun on 17.10.2020.
//  Copyright © 2020 TimunInc. All rights reserved.
//

import Foundation

class Log {
    private static var OVERALL = true
    
    private static var FIRE_ENABLED = false
    private static var PREFS_ENABLED = true
    private static var COREDATA_ENABLED = false
    private static var FRC_ENABLED = false
    private static var ARCH_ENABLED = true
    private static var PROFILE_ENABLED = false

    static func arch(_ message: String) {
        log(message, ARCH_ENABLED)
    }
    
    static func fire(_ message: String) {
        log(message, FIRE_ENABLED)
    }
    
    static func profile(_ message: String) {
        log(message, PROFILE_ENABLED)
    }

    static func prefs(_ message: String) {
        log(message, PREFS_ENABLED)
    }
    
    static func frc(_ message: String) {
        log(message, FRC_ENABLED)
    }

    static func coredata(_ message: String) {
        log(message, COREDATA_ENABLED)
    }

    static func delimiter(_ title: String) {
        log("", OVERALL)
        log("/_/_/_/_/_/_/_/_/\(title)_/_/_/_/_/_/_/_/_/_/", OVERALL)
        log("", OVERALL)
    }
    
    private static func log(_ message: String, _ condition: Bool) {
        if condition {
            print(message)
        }
    }
}

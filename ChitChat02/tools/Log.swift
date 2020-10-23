//
//  Log.swift
//  ChitChat02
//
//  Created by Timun on 17.10.2020.
//  Copyright © 2020 TimunInc. All rights reserved.
//

import Foundation

class Log {
    private static var FIRE_ENABLED = false
    private static var PREFS_ENABLED = false
    private static var OLDSCHOOL_ENABLED = true

    static func fire(_ message: String) {
        log(message, FIRE_ENABLED)
    }
    
    static func prefs(_ message: String) {
        log(message, PREFS_ENABLED)
    }
    
    static func oldschool(_ message: String) {
        log(message, OLDSCHOOL_ENABLED)
    }
    
    private static func log(_ message: String, _ condition: Bool) {
        if condition {
            print(message)
        }
    }
}

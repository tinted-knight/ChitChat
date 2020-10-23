//
//  ThemeManager.swift
//  ChitChat02
//
//  Created by Timun on 02.10.2020.
//  Copyright © 2020 TimunInc. All rights reserved.
//

import Foundation
import UIKit

class ThemeManager {
    static let key = "key-theme"
    
    static private var current: Theme?
    
    static func apply(theme: Theme) {
        current = theme
        let themeData = get()
        MessageCell.appearance().backgroundColor = themeData.backgroundColor
        HeaderCell.appearance().backgroundColor = themeData.backgroundColor
        UILabel.appearance().textColor = themeData.textColor
        
        UITextView.appearance().textColor = themeData.textColor
        UITextView.appearance().backgroundColor = themeData.buttonBgColor
        
        UITextField.appearance().backgroundColor = themeData.buttonBgColor
        
        UIView.appearance().tintColor = themeData.tintColor
        UIBarButtonItem.appearance().tintColor = themeData.tintColor
        switch themeData.brightness {
            case .light:
                UINavigationBar.appearance().barStyle = .default
            case .dark:
                UINavigationBar.appearance().barStyle = .black
        }
    }
    
    static func get() -> ThemeModel {
        return fakeThemeData[current?.rawValue ?? 2]
    }
}

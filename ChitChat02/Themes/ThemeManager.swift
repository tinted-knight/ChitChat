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
    static private var current: Theme?
    
    static func apply(theme: Theme) {
        current = theme
        MessageCell.appearance().backgroundColor = get().backgroundColor
        HeaderCell.appearance().backgroundColor = get().backgroundColor
        UILabel.appearance().textColor = get().textColor
        UITextView.appearance().textColor = get().textColor
    }
    
    static func get() -> ThemeModel {
        return fakeThemeData[current?.rawValue ?? 2]
    }
}

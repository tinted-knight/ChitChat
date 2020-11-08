//
//  ThemeModelNew.swift
//  ChitChat02
//
//  Created by Timun on 08.11.2020.
//  Copyright © 2020 TimunInc. All rights reserved.
//

import Foundation

protocol IThemeModelNew {
    // theme list
    // load
    // save
    var currentTheme: Theme { get }
}

class ThemeModelNew: IThemeModelNew {

    private let themeService: IThemeService
    
    lazy var currentTheme: Theme = self.themeService.theme
    
    init(themeService: IThemeService) {
        self.themeService = themeService
    }
}

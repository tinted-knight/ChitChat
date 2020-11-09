//
//  ThemesService.swift
//  ChitChat02
//
//  Created by Timun on 08.11.2020.
//  Copyright © 2020 TimunInc. All rights reserved.
//

import Foundation

protocol IThemeService {
    var theme: AppTheme { get }

    var classic: ThemeModel { get }
    
    var dark: ThemeModel { get }
    
    var alternative: ThemeModel { get }
    
    func save(theme: AppTheme)
}

class ThemeService: IThemeService {
    private let storage: IKeyValueStorage
    
    private let themes: [ThemeModel]
    
    let theme: AppTheme
    
    lazy var classic: ThemeModel = self.themes[0]

    lazy var dark: ThemeModel = self.themes[2]

    lazy var alternative: ThemeModel = self.themes[1]

    init(storage: IKeyValueStorage, availableThemes themes: [ThemeModel]) {
        self.storage = storage
        self.themes = themes
        let themeId = storage.integer(key: "key-theme")
        Log.arch("theme loaded \(themeId)")
        self.theme = AppTheme(rawValue: themeId) ?? AppTheme.classic
    }
    
    func save(theme: AppTheme) {
        Log.arch("save theme \(theme)")
        storage.save(value: theme.rawValue, forKey: "key-theme")
    }
}

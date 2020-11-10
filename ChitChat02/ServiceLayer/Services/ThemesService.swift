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

    var classic: AppThemeData { get }
    
    var dark: AppThemeData { get }
    
    var alternative: AppThemeData { get }
    
    func save(theme: AppTheme)
}

class ThemeService: IThemeService {
    private let storage: IKeyValueStorage
    
    private let dataManager: IThemeDataManager
    
    private let themes: [AppThemeData]
    
    let theme: AppTheme
    
    lazy var classic: AppThemeData = self.themes[0]

    lazy var dark: AppThemeData = self.themes[2]

    lazy var alternative: AppThemeData = self.themes[1]

    init(storage: IKeyValueStorage, dataManager: IThemeDataManager, availableThemes themes: [AppThemeData]) {
        self.storage = storage
        self.dataManager = dataManager
        self.themes = themes
        let themeId = storage.integer(key: "key-theme")
        Log.arch("theme loaded \(themeId)")
        self.theme = AppTheme(rawValue: themeId) ?? AppTheme.classic
    }
    
    func save(theme: AppTheme) {
        Log.arch("save theme \(theme)")
        storage.save(value: theme.rawValue, forKey: "key-theme")
        switch theme {
        case .classic:
            dataManager.save(classic)
        case .black:
            dataManager.save(dark)
        case .yellow:
            dataManager.save(alternative)
        }
    }
}

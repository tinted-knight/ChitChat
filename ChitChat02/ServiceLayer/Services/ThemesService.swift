//
//  ThemesService.swift
//  ChitChat02
//
//  Created by Timun on 08.11.2020.
//  Copyright © 2020 TimunInc. All rights reserved.
//

import Foundation

protocol IThemeService {
    var theme: Theme { get }
}

class ThemeService: IThemeService {
    private let storage: IKeyValueStorage
    
    let theme: Theme
    
    init(storage: IKeyValueStorage) {
        self.storage = storage
        
        let themeId = storage.integer(key: "key-theme")
        self.theme = Theme(rawValue: themeId) ?? Theme.classic
    }
}

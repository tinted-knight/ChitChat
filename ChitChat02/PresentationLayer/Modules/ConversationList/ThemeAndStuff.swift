//
//  ThemeAndStuff.swift
//  ChitChat02
//
//  Created by Timun on 18.10.2020.
//  Copyright © 2020 TimunInc. All rights reserved.
//

import Foundation

// MARK: ThemesPickerDelegate and stuff
extension ChannelsViewController: IThemeModelDelegate {
    
    func apply(_ theme: AppThemeData) {
        Log.arch("channels apply theme")
        applyTheme(theme)
    }
    
    func applyTheme(_ value: AppThemeData) {
        channelsTableView.reloadData()
        
        updateNavbarAppearence(value)
        navigationController?.navigationBar.tintColor = value.tintColor
        // need to duplicate here
        switch value.brightness {
        case .dark:
            navigationController?.navigationBar.barStyle = .black
        case .light:
            navigationController?.navigationBar.barStyle = .default
        }
    }
    
    func updateNavbarAppearence(_ value: AppThemeData) {
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: value.textColor]
        navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: value.textColor]
    }
}

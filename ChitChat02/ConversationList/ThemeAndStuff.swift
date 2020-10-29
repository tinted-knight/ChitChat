//
//  ThemeAndStuff.swift
//  ChitChat02
//
//  Created by Timun on 18.10.2020.
//  Copyright © 2020 TimunInc. All rights reserved.
//

import Foundation

// MARK: ThemesPickerDelegate and stuff
extension ConversationListViewController: ThemesPickerDelegate {
    func theme(picked value: Theme) {
        //
    }

    func result(_ value: Theme, _ saveChoice: Bool) {
        if saveChoice {
            applyTheme(value)
            saveCurrentTheme()
        } else {
            //
        }
    }
    
    func applyTheme(_ value: Theme) {
        currentTheme = value
        channelsTableView.reloadData()
        
        ThemeManager.apply(theme: value)
        
        updateNavbarAppearence()
        navigationController?.navigationBar.tintColor = ThemeManager.get().tintColor
        // inspite of setting NavBarStyle in ThemeManager need to duplicate here
        switch ThemeManager.get().brightness {
        case .dark:
            navigationController?.navigationBar.barStyle = .black
        case .light:
            navigationController?.navigationBar.barStyle = .default
        }
    }
    
    func updateNavbarAppearence() {
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: ThemeManager.get().textColor]
        navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: ThemeManager.get().textColor]
    }
    
    func saveCurrentTheme() {
        applog(#function)
        let pref = UserDefaults.standard
        pref.set(currentTheme.rawValue, forKey: ThemeManager.key)
        themeDataManager.save(ThemeManager.get())
    }
    
    func loadAppTheme() -> Theme {
        let prefs = UserDefaults.standard
        return Theme(rawValue: prefs.integer(forKey: ThemeManager.key)) ?? Theme.classic
    }
}

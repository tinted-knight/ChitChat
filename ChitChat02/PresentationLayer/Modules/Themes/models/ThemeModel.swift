//
//  ThemeModelNew.swift
//  ChitChat02
//
//  Created by Timun on 08.11.2020.
//  Copyright © 2020 TimunInc. All rights reserved.
//

import Foundation
import UIKit

protocol IThemeModel {
    var delegate: IThemeModelDelegate? { get set }
    
    var currentTheme: AppTheme { get }
    
    var classic: AppThemeData { get }
    
    var dark: AppThemeData { get }
    
    var alternative: AppThemeData { get }
    
    func picked(theme: AppTheme)
    
    func applyCurrent()
    
    func getThemeData() -> AppThemeData
}

protocol IThemeModelDelegate: class {
    func apply(_ theme: AppThemeData)
}

class ThemeModel: IThemeModel {

    private let themeService: IThemeService
    
    lazy var currentTheme: AppTheme = self.themeService.theme
    
    lazy var classic: AppThemeData = self.themeService.classic
    
    lazy var dark: AppThemeData = self.themeService.dark

    lazy var alternative: AppThemeData = self.themeService.alternative
    
    weak var delegate: IThemeModelDelegate?

    init(themeService: IThemeService) {
        self.themeService = themeService
    }
    
    func picked(theme: AppTheme) {
        if theme != currentTheme {
            Log.arch("theme will save")
            themeService.save(theme: theme)
            currentTheme = theme
            applyCurrent()
        } else {
            Log.arch("no need to save")
        }
    }
    
    func applyCurrent() {
        let themeData = getThemeData()
        MessageCell.appearance().backgroundColor = themeData.backgroundColor
        UILabel.appearance().textColor = themeData.textColor

        UITextView.appearance().textColor = themeData.textColor
        UITextView.appearance().backgroundColor = themeData.buttonBgColor

        UITextField.appearance().backgroundColor = themeData.backgroundColor

        UIView.appearance().tintColor = themeData.tintColor
        UIBarButtonItem.appearance().tintColor = themeData.tintColor
        switch themeData.brightness {
        case .light:
            UINavigationBar.appearance().barStyle = .default
        case .dark:
            UINavigationBar.appearance().barStyle = .black
        }
        
        delegate?.apply(themeData)
    }
    
    func getThemeData() -> AppThemeData {
        switch currentTheme {
        case .classic:
            return classic
        case .black:
            return dark
        case .yellow:
            return alternative
        }
    }
}

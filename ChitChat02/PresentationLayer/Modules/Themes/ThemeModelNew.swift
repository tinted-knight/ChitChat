//
//  ThemeModelNew.swift
//  ChitChat02
//
//  Created by Timun on 08.11.2020.
//  Copyright © 2020 TimunInc. All rights reserved.
//

import Foundation
import UIKit

protocol IThemeModelNew {
    var delegate: IThemeModelDelegate? { get set }
    
    var currentTheme: AppTheme { get }
    
    var classic: ThemeModel { get }
    
    var dark: ThemeModel { get }
    
    var alternative: ThemeModel { get }
    
    func picked(theme: AppTheme)
    
    func applyCurrent()
    
    func getThemeData() -> ThemeModel
}

protocol IThemeModelDelegate: class {
    func apply(_ theme: ThemeModel)
}

class ThemeModelNew: IThemeModelNew {

    private let themeService: IThemeService
    
    lazy var currentTheme: AppTheme = self.themeService.theme
    
    lazy var classic: ThemeModel = self.themeService.classic
    
    lazy var dark: ThemeModel = self.themeService.dark

    lazy var alternative: ThemeModel = self.themeService.alternative
    
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
    
    func getThemeData() -> ThemeModel {
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

//
//  ThemesViewController.swift
//  ChitChat02
//
//  Created by Timun on 02.10.2020.
//  Copyright © 2020 TimunInc. All rights reserved.
//

import UIKit

class ThemesViewController: UIViewController {
    
    static func instance() -> ThemesViewController? {
        let storyboard = UIStoryboard(name: "ThemesViewController", bundle: nil)
        return storyboard.instantiateInitialViewController() as? ThemesViewController
    }
    
    var themeModel: IThemeModel!
    
    @IBOutlet weak var buttonRed: UIButton!
    @IBOutlet weak var buttonYellow: UIButton!
    @IBOutlet weak var buttonGreen: UIButton!
    
    @IBOutlet weak var imageClassic: UIImageView!
    @IBOutlet weak var imageYellow: UIImageView!
    @IBOutlet weak var imageBlack: UIImageView!
    
    var activeTheme: AppTheme!
    var selectedTheme: AppTheme = .classic
    private var selectedImageView: UIImageView? {
        switch selectedTheme {
        case .classic:
            return imageClassic
        case .yellow:
            return imageYellow
        case .black:
            return imageBlack
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        activeTheme = themeModel.currentTheme
        selectedTheme = activeTheme
        
        prepareUi()
        setupListeners()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        themeModel.picked(theme: selectedTheme)

        super.viewWillDisappear(animated)
    }
    
    private func prepareUi() {
        title = "Settings"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Cancel",
            style: .plain,
            target: self, action: #selector(cancelOnTap)
        )

        buttonRed.setTitle(fakeThemeData[0].name, for: .normal)
        buttonYellow.setTitle(fakeThemeData[1].name, for: .normal)
        buttonGreen.setTitle(fakeThemeData[2].name, for: .normal)
        
        imageClassic.layer.cornerRadius = 14
        imageYellow.layer.cornerRadius = 14
        imageBlack.layer.cornerRadius = 14
        
        setSelectedTheme(selectedTheme, force: true)
    }
    
    private func setupListeners() {
        buttonRed.addTarget(self, action: #selector(selectClassicTheme), for: .touchUpInside)
        buttonYellow.addTarget(self, action: #selector(selectAlternativeTheme), for: .touchUpInside)
        buttonGreen.addTarget(self, action: #selector(selectDarkTheme), for: .touchUpInside)
        
        imageClassic.isUserInteractionEnabled = true
        imageClassic.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(selectClassicTheme))
        )
        
        imageYellow.isUserInteractionEnabled = true
        imageYellow.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(selectAlternativeTheme))
        )
        
        imageBlack.isUserInteractionEnabled = true
        imageBlack.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(selectDarkTheme))
        )
    }
    
    @objc private func cancelOnTap() {
        revertTheme(to: activeTheme)
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func selectClassicTheme() {
        setSelectedTheme(.classic)
    }
    
    @objc private func selectAlternativeTheme() {
        setSelectedTheme(.yellow)
    }
    
    @objc private func selectDarkTheme() {
        setSelectedTheme(.black)
    }
    
    private func setSelectedTheme(_ value: AppTheme, force: Bool = false) {
        guard force || value != selectedTheme else {
            return
        }
        applyThemeForPreview(value)
        selectedImageView?.isChoosed(false)
        selectedTheme = value
        selectedImageView?.isChoosed(true)
    }
    
    private func revertTheme(to value: AppTheme) {
        applyThemeForPreview(value)
    }
    
    private func applyThemeForPreview(_ value: AppTheme) {
        view.backgroundColor = fakeThemeData[value.rawValue].backgroundColor
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: fakeThemeData[value.rawValue].textColor]
        navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: fakeThemeData[value.rawValue].textColor]
        navigationController?.navigationBar.tintColor = fakeThemeData[value.rawValue].tintColor
    }
}

extension UIImageView {
    // Display blue border around selected button
    func isChoosed(_ value: Bool) {
        if value {
            self.layer.borderWidth = 3
            self.layer.borderColor = UIColor.blue.cgColor
        } else {
            self.layer.borderWidth = 1
            self.layer.borderColor = UIColor.gray.cgColor
        }
    }
}

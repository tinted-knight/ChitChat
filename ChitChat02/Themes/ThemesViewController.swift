//
//  ThemesViewController.swift
//  ChitChat02
//
//  Created by Timun on 02.10.2020.
//  Copyright © 2020 TimunInc. All rights reserved.
//

import UIKit

protocol ThemesPickerDelegate {
    func theme(picked value: Theme)
    func result(_ value: Theme, _ saveChoice: Bool)
}

class ThemesViewController: UIViewController {
    
    static func instance() -> ThemesViewController? {
        let storyboard = UIStoryboard(name: String.init(describing: self), bundle: nil)
        return storyboard.instantiateInitialViewController() as? ThemesViewController
    }
    
    var delegate: ThemesPickerDelegate?
    
    var themePicked: ((Theme) -> Void)?
    var result: ((Theme, Bool) -> Void)?
    
    private var saveChoice = true
    
    @IBOutlet weak var buttonRed: UIButton!
    @IBOutlet weak var buttonYellow: UIButton!
    @IBOutlet weak var buttonGreen: UIButton!
    
    @IBOutlet weak var imageRed: UIImageView!
    @IBOutlet weak var imageYellow: UIImageView!
    @IBOutlet weak var imageGreen: UIImageView!
    
    var activeTheme: Theme = .classic
    var selectedTheme: Theme = .classic
    private var selectedImageView: UIImageView? {
        switch selectedTheme {
            case .classic:
                return imageRed
            case .yellow:
                return imageYellow
            case .black:
                return imageGreen
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectedTheme = activeTheme
        
        prepareUi()
        setupListeners()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        result?(selectedTheme, saveChoice)
        delegate?.result(selectedTheme, saveChoice)
        
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
        
        imageRed.layer.cornerRadius = 14
        imageYellow.layer.cornerRadius = 14
        imageGreen.layer.cornerRadius = 14
        
        setSelectedTheme(selectedTheme, force: true)
    }
    
    private func setupListeners() {
        buttonRed.addTarget(self, action: #selector(selectRedTheme), for: .touchUpInside)
        buttonYellow.addTarget(self, action: #selector(selectYellowTheme), for: .touchUpInside)
        buttonGreen.addTarget(self, action: #selector(selectGreenTheme), for: .touchUpInside)
        
        imageRed.isUserInteractionEnabled = true
        imageRed.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(selectRedTheme))
        )
        
        imageYellow.isUserInteractionEnabled = true
        imageYellow.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(selectYellowTheme))
        )
        
        imageGreen.isUserInteractionEnabled = true
        imageGreen.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(selectGreenTheme))
        )
    }
    
    @objc private func cancelOnTap() {
        saveChoice = false
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func selectRedTheme() {
        setSelectedTheme(.classic)
    }
    
    @objc private func selectYellowTheme() {
        setSelectedTheme(.yellow)
    }
    
    @objc private func selectGreenTheme() {
        setSelectedTheme(.black)
    }
    
    private func setSelectedTheme(_ value: Theme, force: Bool = false) {
        guard force || value != selectedTheme else {
            return
        }
        applyThemeForPreview(value)
        selectedImageView?.isChoosed(false)
        selectedTheme = value
        selectedImageView?.isChoosed(true)
        
        delegate?.theme(picked: value)
        themePicked?(value)
    }
    
    private func applyThemeForPreview(_ value: Theme) {
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

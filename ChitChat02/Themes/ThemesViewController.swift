//
//  ThemesViewController.swift
//  ChitChat02
//
//  Created by Timun on 02.10.2020.
//  Copyright © 2020 TimunInc. All rights reserved.
//

import UIKit

enum Theme: Int {
    case red = 0
    case yellow = 1
    case green = 2
}

protocol ThemesPickerDelegate {
    func theme(picked value: Theme)
}

class ThemesViewController: UIViewController {
    
    static func instance() -> ThemesViewController? {
        let storyboard = UIStoryboard(name: String.init(describing: self), bundle: nil)
        return storyboard.instantiateInitialViewController() as? ThemesViewController
    }
    
    var delegate: ThemesPickerDelegate?
    
    var themePicked: ((Theme) -> Void)?
    
    @IBOutlet weak var buttonRed: UIButton!
    @IBOutlet weak var buttonYellow: UIButton!
    @IBOutlet weak var buttonGreen: UIButton!
    
    @IBOutlet weak var imageRed: UIImageView!
    @IBOutlet weak var imageYellow: UIImageView!
    @IBOutlet weak var imageGreen: UIImageView!
    
    var selectedTheme: Theme = .red
    private var selectedImageView: UIImageView? {
        switch selectedTheme {
            case .red:
                return imageRed
            case .yellow:
                return imageYellow
            case .green:
                return imageGreen
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareUi()
        setupListeners()
    }
    
    private func prepareUi() {
        title = "Settings"
        
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
    
    @objc private func selectRedTheme() {
        setSelectedTheme(.red)
    }
    
    @objc private func selectYellowTheme() {
        setSelectedTheme(.yellow)
    }
    
    @objc private func selectGreenTheme() {
        setSelectedTheme(.green)
    }
    
    private func setSelectedTheme(_ value: Theme, force: Bool = false) {
        guard force || value != selectedTheme else {
            return
        }
        view.backgroundColor = fakeThemeData[value.rawValue].backgroundColor
        selectedImageView?.isChoosed(false)
        selectedTheme = value
        selectedImageView?.isChoosed(true)

        delegate?.theme(picked: value)
        themePicked?(value)
    }
}

extension UIImageView {
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

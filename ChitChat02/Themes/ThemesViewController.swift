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
        let storyboard = UIStoryboard(name: String.init(describing: self), bundle: nil)
        return storyboard.instantiateInitialViewController() as? ThemesViewController
    }
    
    @IBOutlet weak var buttonTheme01: UIButton!
    @IBOutlet weak var buttonTheme02: UIButton!
    @IBOutlet weak var buttonTheme03: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareUi()
        buttonTheme01.addTarget(self, action: #selector(themeOnTap(_:)), for: .touchUpInside)
        buttonTheme02.addTarget(self, action: #selector(themeOnTap(_:)), for: .touchUpInside)
        buttonTheme03.addTarget(self, action: #selector(themeOnTap(_:)), for: .touchUpInside)
    }
    
    private func prepareUi() {
        title = "Settings"
    }
    
    @objc private func themeOnTap(_ sender: UIView?) {
        applog(#function)
    }
    
}

//
//  ViewController.swift
//  ChitChat02
//
//  Created by Timun on 13.09.2020.
//  Copyright © 2020 TimunInc. All rights reserved.
//

import UIKit

private let SEGUE_SHOW_PROFILE = "action_show_profile"

class ViewController: UIViewController {

    @IBOutlet weak var buttonShowProfile: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        applog(#function)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onShowProfileTap(_ sender: Any) {
        performSegue(withIdentifier: SEGUE_SHOW_PROFILE, sender: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        applog(#function)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        applog(#function)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        applog(#function)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        applog(#function)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        applog(#function)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        applog(#function)
    }

}


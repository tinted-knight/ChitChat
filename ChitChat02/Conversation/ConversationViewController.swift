//
//  ConversationViewController.swift
//  ChitChat02
//
//  Created by Timun on 28.09.2020.
//  Copyright © 2020 TimunInc. All rights reserved.
//

import UIKit

class ConversationViewController: UIViewController {

    var contactName: String?
    
    private let nonameContact = "Noname"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareUi()
    }
    
    private func prepareUi() {
        title = contactName ?? nonameContact
    }
}

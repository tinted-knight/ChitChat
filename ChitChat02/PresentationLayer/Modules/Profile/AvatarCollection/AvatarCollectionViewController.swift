//
//  AvatarCollectionViewController.swift
//  ChitChat02
//
//  Created by Timun on 16.11.2020.
//  Copyright © 2020 TimunInc. All rights reserved.
//

import Foundation
import UIKit

class AvatarCollectionViewController: UIViewController {
    static func instance() -> AvatarCollectionViewController? {
        let storyboard = UIStoryboard(name: "AvatarCollectionViewController", bundle: nil)
        return storyboard.instantiateInitialViewController() as? AvatarCollectionViewController
    }
    
    init() {
        super.init(nibName: "AvatarCollectionViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

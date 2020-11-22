//
//  Channels Navigation+Transition.swift
//  ChitChat02
//
//  Created by Timun on 22.11.2020.
//  Copyright © 2020 TimunInc. All rights reserved.
//

import Foundation
import UIKit

extension ChannelsViewController {
    @objc func profileOnTap() {
        let controller = presentationAssembly.profileViewController()
        controller.transitioningDelegate = self
//        controller.modalPresentationStyle = .fullScreen
        navigationController?.present(controller, animated: true, completion: nil)
    }
    
    @objc func settingsOnTap() {
        let controller = presentationAssembly.themesViewController()
        navigationController?.pushViewController(controller, animated: true)
    }
}

extension ChannelsViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController,
                             presenting: UIViewController,
                             source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.presenting = true
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.presenting = false
        return transition
    }
}

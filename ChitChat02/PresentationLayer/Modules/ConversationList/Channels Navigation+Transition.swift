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

extension ChannelsViewController: UIViewControllerTransitioningDelegate, UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController,
                              animationControllerFor operation: UINavigationController.Operation,
                              from fromVC: UIViewController,
                              to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transitions.pushTransition.presenting = (operation == .push)
        return transitions.pushTransition
    }
    
    func animationController(forPresented presented: UIViewController,
                             presenting: UIViewController,
                             source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transitions.presentTransition.presenting = true
        return transitions.presentTransition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transitions.presentTransition.presenting = false
        return transitions.presentTransition
    }
}

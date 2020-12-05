//
//  TransitionProvider.swift
//  ChitChat02
//
//  Created by Timun on 24.11.2020.
//  Copyright © 2020 TimunInc. All rights reserved.
//

import Foundation
import UIKit

class TransitionProvider: NSObject, ITransitionProvider {
    private lazy var presentTransition: IViewControllerTransition = TopLeftRightBottom()
    private lazy var pushTransition: IViewControllerTransition = RotatingCard()

    func navigationController(_ navigationController: UINavigationController,
                              animationControllerFor operation: UINavigationController.Operation,
                              from fromVC: UIViewController,
                              to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        pushTransition.presenting = (operation == .push)
        return pushTransition
    }
    
    func animationController(forPresented presented: UIViewController,
                             presenting: UIViewController,
                             source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        presentTransition.presenting = true
        return presentTransition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        presentTransition.presenting = false
        return presentTransition
    }
}

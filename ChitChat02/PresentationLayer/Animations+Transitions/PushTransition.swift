//
//  PushTransition.swift
//  ChitChat02
//
//  Created by Timun on 23.11.2020.
//  Copyright © 2020 TimunInc. All rights reserved.
//

import Foundation
import UIKit

class TopLeftRightBottom: NSObject, IViewControllerTransition {

    private let duration = 1.5
    var presenting: Bool = true
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if presenting {
            animatePush(using: transitionContext)
        } else {
            animatePop(using: transitionContext)
        }
    }

    func animatePush(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView

        guard let fromVC = transitionContext.viewController(forKey: .from) else { return }
        guard let toVc = transitionContext.viewController(forKey: .to) else { return }
        
        let offScreenRightBottom = CGAffineTransform(translationX: containerView.frame.width,
                                                     y: containerView.frame.height)

        toVc.view.transform = offScreenRightBottom
        
        containerView.insertSubview(toVc.view, aboveSubview: fromVC.view)
        
        UIView.animate(
            withDuration: duration,
            delay: 0.0,
            usingSpringWithDamping: 0.4,
            initialSpringVelocity: 0.81,
            options: [],
            animations: {
                toVc.view.transform = .identity
        }, completion: {_ in
            transitionContext.completeTransition(true)
        })
    }

    func animatePop(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView

        guard let fromVC = transitionContext.viewController(forKey: .from) else { return }
        guard let toVC = transitionContext.viewController(forKey: .to) else { return }

        let offScreenTopLeft = CGAffineTransform(translationX: -containerView.frame.width,
                                                 y: -containerView.frame.height)

        toVC.view.transform = offScreenTopLeft

        containerView.insertSubview(toVC.view, aboveSubview: fromVC.view)

        UIView.animate(
            withDuration: duration,
            delay: 0.0,
            usingSpringWithDamping: 0.4,
            initialSpringVelocity: 0.81,
            options: [],
            animations: {
                toVC.view.transform = .identity
        }, completion: {_ in
            transitionContext.completeTransition(true)
        })
    }
}

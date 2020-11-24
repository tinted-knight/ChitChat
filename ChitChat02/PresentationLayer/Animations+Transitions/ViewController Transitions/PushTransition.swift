//
//  PushTransition.swift
//  ChitChat02
//
//  Created by Timun on 23.11.2020.
//  Copyright © 2020 TimunInc. All rights reserved.
//

import Foundation
import UIKit

private struct ViewHelper {
    let centerX: CGFloat
    let centerY: CGFloat
    let width: CGFloat
    let height: CGFloat
    let center: CGPoint
    
    init(for view: UIView) {
        self.center = view.center
        self.centerX = view.center.x
        self.centerY = view.center.y
        self.width = view.frame.width
        self.height = view.frame .height
    }
}

class RotatingCard: NSObject, IViewControllerTransition {

    private let duration = 0.5
    var presenting: Bool = true
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from),
            let toVC = transitionContext.viewController(forKey: .to) else {
                transitionContext.completeTransition(false)
                return
        }

        let containerView = transitionContext.containerView
        let helper = ViewHelper(for: containerView)

        CATransaction.setCompletionBlock {
            transitionContext.completeTransition(true)
        }

        containerView.insertSubview(toVC.view, aboveSubview: fromVC.view)

        if presenting {
            animate(from: fromVC, with: pushFromAnimation(helper),
                    to: toVC, with: pushToAnimation(helper))
        } else {
            containerView.sendSubviewToBack(toVC.view)
            animate(from: fromVC, with: popFromAnimation(helper),
                    to: toVC, with: popToAnimation(helper))
        }
    }
        
    func animate(from fromVC: UIViewController, with fromAnimation: CAAnimationGroup,
                 to toVC: UIViewController, with toAnimation: CAAnimationGroup) {
        toVC.view.layer.add(toAnimation, forKey: "to-anim")
        fromVC.view.layer.add(fromAnimation, forKey: "from-anim")
    }

    private func pushFromAnimation(_ helper: ViewHelper) -> CAAnimationGroup {
        let scaleX = CABasicAnimation(keyPath: "transform.scale.x")
        scaleX.fromValue = 1.0
        scaleX.toValue = 0.8
        
        let scaleY = CABasicAnimation(keyPath: "transform.scale.y")
        scaleY.fromValue = 1.0
        scaleY.toValue = 0.8
        
        let alpha = CABasicAnimation(keyPath: "opacity")
        alpha.fromValue = 1.0
        alpha.toValue = 0.0
        
        let group = CAAnimationGroup()
        group.duration = duration
        group.repeatCount = 1
        group.autoreverses = false
        
        group.animations = [alpha, scaleX, scaleY]
        
        return group
    }

    private func pushToAnimation(_ helper: ViewHelper) -> CAAnimationGroup {
        let position = CABasicAnimation(keyPath: "position")
        position.fromValue = CGPoint(x: helper.centerX + helper.width, y: helper.centerY)
        position.toValue = helper.center
        
        let alpha = CABasicAnimation(keyPath: "opacity")
        alpha.fromValue = 0.0
        alpha.toValue = 1.0

        let scaleX = CAKeyframeAnimation(keyPath: "transform.scale.x")
        scaleX.values = [0.9, 1.0]
        scaleX.keyTimes = [0.8, 1.0]

        let scaleY = CAKeyframeAnimation(keyPath: "transform.scale.y")
        scaleY.values = [0.9, 1.0]
        scaleY.keyTimes = [0.8, 1.0]

        let rotation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.fromValue = (Double.pi / 180) * 18
        rotation.toValue = 0.0
        
        let group = CAAnimationGroup()
        group.duration = duration
        group.repeatCount = 1
        group.autoreverses = false
        group.timingFunction = CAMediaTimingFunction(name: .easeOut)
        
        group.animations = [position, scaleX, scaleY, rotation]
        
        return group
    }

    private func popFromAnimation(_ helper: ViewHelper) -> CAAnimationGroup {
        let position = CABasicAnimation(keyPath: "position")
        position.fromValue = helper.center
        position.toValue = CGPoint(x: helper.centerX + helper.width, y: helper.centerY)
        
        let alpha = CABasicAnimation(keyPath: "opacity")
        alpha.fromValue = 1.0
        alpha.toValue = 0.0

        let scaleX = CAKeyframeAnimation(keyPath: "transform.scale.x")
        scaleX.values = [1.0, 0.9]
        scaleX.keyTimes = [0.0, 0.2]

        let scaleY = CAKeyframeAnimation(keyPath: "transform.scale.y")
        scaleY.values = [1.0, 0.9]
        scaleY.keyTimes = [0.0, 0.0]

        let rotation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.fromValue = 0.0
        rotation.toValue = (Double.pi / 180) * 18
        
        let group = CAAnimationGroup()
        group.duration = duration
        group.repeatCount = 1
        group.autoreverses = false
        group.timingFunction = CAMediaTimingFunction(name: .easeOut)
        
        group.animations = [position, scaleX, scaleY, rotation]
        
        return group
    }

    private func popToAnimation(_ helper: ViewHelper) -> CAAnimationGroup {
        let scaleX = CABasicAnimation(keyPath: "transform.scale.x")
        scaleX.fromValue = 0.8
        scaleX.toValue = 1.0
        
        let scaleY = CABasicAnimation(keyPath: "transform.scale.y")
        scaleY.fromValue = 0.8
        scaleY.toValue = 1.0
        
        let alpha = CABasicAnimation(keyPath: "opacity")
        alpha.fromValue = 0.0
        alpha.toValue = 1.0
        
        let group = CAAnimationGroup()
        group.duration = duration
        group.repeatCount = 1
        group.autoreverses = false
        
        group.animations = [alpha, scaleX, scaleY]
        
        return group
    }
}

//
//  AwesomeTransition.swift
//  ChitChat02
//
//  Created by Timun on 22.11.2020.
//  Copyright © 2020 TimunInc. All rights reserved.
//

import Foundation
import UIKit

class TopLeftRightBottom: NSObject, IViewControllerTransition {
    
    private let duration = 1.5
    var presenting = true
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        //        guard let fromView = transitionContext.view(forKey: .from) else {
        //            print("from in nil")
        //            return
        //        }
        let fromView = transitionContext.view(forKey: .from)
        //        guard let toView = transitionContext.view(forKey: .to) else {
        //            print("to is nil")
        //            return
        //        }
        let toView = transitionContext.view(forKey: .to)
        
        let offScreenTopLeft = CGAffineTransform(translationX: -containerView.frame.width,
                                                 y: -containerView.frame.height)
        let offScreenRightBottom = CGAffineTransform(translationX: containerView.frame.width,
                                                     y: containerView.frame.height)
        print("presenting = \(presenting)")
        if presenting {
            toView?.transform = offScreenTopLeft
        }
        
        if let toView = toView {
            containerView.addSubview(toView)
        } else {
            print("to == nil")
        }
        
        if let fromView = fromView {
            containerView.addSubview(fromView)
        } else {
            print("from == nil")
        }

        UIView.animate(withDuration: duration,
                       delay: 0.0,
                       usingSpringWithDamping: 0.4,
                       initialSpringVelocity: 0.81,
                       options: [],
                       animations: { [weak self] in
                        guard let self = self else { return }
                            if self.presenting {
                                toView?.transform = .identity
                            } else {
                                fromView?.transform = offScreenRightBottom
                            }
                       },
                       completion: { (_) in
                            transitionContext.completeTransition(true)
                       }
        )
    }
}

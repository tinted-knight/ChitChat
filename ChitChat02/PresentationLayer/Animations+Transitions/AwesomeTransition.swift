//
//  AwesomeTransition.swift
//  ChitChat02
//
//  Created by Timun on 22.11.2020.
//  Copyright © 2020 TimunInc. All rights reserved.
//

import Foundation
import UIKit

protocol IViewControllerTransition: UIViewControllerAnimatedTransitioning {
    var presenting: Bool { get set }
}

class AwesomeTransition: NSObject, IViewControllerTransition {
    
    private let duration = 1.5
    var presenting = true
    private let originFrame = CGRect.zero
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        guard let fromView = transitionContext.view(forKey: .from) else {
            print("from in nil")
            return
        }
        guard let toView = transitionContext.view(forKey: .to) else {
            print("to is nil")
            return
        }
        
        let offScreenBottom = CGAffineTransform(translationX: 0, y: containerView.frame.height)
        let offScreenLeft = CGAffineTransform(translationX: -containerView.frame.width, y: 0)
        
        if presenting {
            toView.transform = offScreenBottom
        } else {
            toView.transform = offScreenLeft
        }
        
        containerView.addSubview(toView)
        containerView.addSubview(fromView)
        
        UIView.animate(withDuration: duration, delay: 0.0,
                       usingSpringWithDamping: 0.4,
                       initialSpringVelocity: 0.81,
                       options: [],
                       animations: {
                            if self.presenting {
                                fromView.transform = offScreenLeft
                                toView.transform = .identity
                            } else {
                                fromView.transform = offScreenBottom
                                toView.transform = .identity
                            }
                       },
                       completion: { (_) in
                            transitionContext.completeTransition(true)
                       }
        )
    }
}

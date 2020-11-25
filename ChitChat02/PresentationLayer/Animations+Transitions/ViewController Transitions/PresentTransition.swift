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
    
    private let duration = 0.5
    var presenting = true
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView

        let fromView = transitionContext.view(forKey: .from)
        let toView = transitionContext.view(forKey: .to)
        
        let offScreenTopLeft = CGAffineTransform(translationX: -containerView.frame.width,
                                                 y: -containerView.frame.height)
        let offScreenRightBottom = CGAffineTransform(translationX: containerView.frame.width,
                                                     y: containerView.frame.height)
        if presenting {
            toView?.transform = offScreenTopLeft
        }
        
        if let toView = toView {
            containerView.addSubview(toView)
        }
        
        if let fromView = fromView {
            containerView.addSubview(fromView)
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

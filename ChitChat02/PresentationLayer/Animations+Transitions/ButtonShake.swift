//
//  ButtonShake.swift
//  ChitChat02
//
//  Created by Timun on 22.11.2020.
//  Copyright © 2020 TimunInc. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
    func shake() {
        let centerX = self.center.x
        let centerY = self.center.y

        let rot = CAKeyframeAnimation(keyPath: "transform.rotation.z")
        rot.values = [
            0.0,
            -(Double.pi / 180) * 18,
            (Double.pi / 180) * 18,
            0.0
        ]
        rot.keyTimes = [0.0, 0.25, 0.75, 1.0]
        
        let keyframe = CAKeyframeAnimation(keyPath: "position")
        keyframe.values = [
            CGPoint(x: centerX, y: centerY),
            CGPoint(x: centerX - 5, y: centerY - 5),
            CGPoint(x: centerX + 5, y: centerY + 5),
            CGPoint(x: centerX - 5, y: centerY + 5),
            CGPoint(x: centerX + 5, y: centerY - 5),
            CGPoint(x: centerX, y: centerY)
        ]
        keyframe.keyTimes = [0.0, 0.2, 0.4, 0.6, 0.8, 1.0]

        let group = CAAnimationGroup()
        group.duration = 0.3
        group.repeatCount = .infinity
        group.autoreverses = false
        
        group.animations = [rot, keyframe]

        self.layer.add(group, forKey: "key-animation")
    }
    
    func stopShaking() {
        self.layer.removeAnimation(forKey: "key-animation")
    }
}

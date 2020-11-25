//
//  Particles.swift
//  ChitChat02
//
//  Created by Timun on 22.11.2020.
//  Copyright © 2020 TimunInc. All rights reserved.
//

import Foundation
import UIKit

protocol IFunController: UIViewController {
    var funLayer: CAEmitterLayer? { get }
}

extension IFunController {
    func startFun(at position: CGPoint) {
        funLayer?.emitterPosition = position
        funLayer?.birthRate = 1.0
        
        if !hasEmitterLayer(), let layer = funLayer {
            view.layer.addSublayer(layer)
        }
    }
    
    private func hasEmitterLayer() -> Bool {
        let emitterLayer = view.layer.sublayers?.first(where: { (layer) -> Bool in
            layer is CAEmitterLayer
        })
        return emitterLayer != nil
    }
    
    func endFun() {
        funLayer?.birthRate = 0.0
    }
    
    func update(position: CGPoint) {
        funLayer?.emitterPosition = position
    }
}

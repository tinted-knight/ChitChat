//
//  FunController.swift
//  ChitChat02
//
//  Created by Timun on 22.11.2020.
//  Copyright © 2020 TimunInc. All rights reserved.
//

import Foundation
import UIKit

class FunController: UIViewController, FunViewController {
    private lazy var emblemCell: CAEmitterCell = {
        var emblemCell = CAEmitterCell()
        emblemCell.contents = UIImage(named: "Emblem")?.cgImage
        emblemCell.scale = 0.05
        emblemCell.emissionRange = CGFloat.pi
        emblemCell.lifetime = 2.0
        emblemCell.birthRate = 10
        emblemCell.velocity = -30
        emblemCell.velocityRange = 100
        emblemCell.xAcceleration = 50
        emblemCell.yAcceleration = 50
        emblemCell.spin = -0.5
        emblemCell.spinRange = 1.0
        emblemCell.alphaSpeed = -0.5
        return emblemCell
    }()

    lazy var funLayer: CAEmitterLayer? = {
        let funLayer = CAEmitterLayer()
        funLayer.emitterSize = CGSize(width: 100.0, height: 0)
        funLayer.emitterShape = .circle
        funLayer.beginTime = CACurrentMediaTime()
        funLayer.emitterCells = [self.emblemCell]
        
        return funLayer
    }()

    override func viewWillDisappear(_ animated: Bool) {
        endFun()
        super.viewWillDisappear(animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleCustomTouch(_:)),
                                               name: NSNotification.Name(rawValue: "TouchPhaseBeganCustomNotification"),
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleCustomTouch(_:)),
                                               name: NSNotification.Name(rawValue: "TouchPhaseMovedCustomNotification"),
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleCustomTouch(_:)),
                                               name: NSNotification.Name(rawValue: "TouchPhaseEndedCustomNotification"),
                                               object: nil)
    }
    
    @objc private func handleCustomTouch(_ event: NSNotification) {
        print(event.name)
//        guard let object = event.object as? UIEvent else {
//            print("object is nil")
//            return
//        }
//
//        if let touch = object.allTouches?.first {
//            let position = touch.location(in: view)
//            startFun(at: position)
//        }
    }
}

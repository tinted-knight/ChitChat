//
//  UIWindow.swift
//  ChitChat02
//
//  Created by Timun on 23.11.2020.
//  Copyright © 2020 TimunInc. All rights reserved.
//

import Foundation
import UIKit

extension Notification.Name {
    static let touchPhaseBegan = Notification.Name("TouchPhaseBegan-Notification")
    static let touchPhaseMoved = Notification.Name("TouchPhaseMoved-Notification")
    static let touchPhaseEnded = Notification.Name("TouchPhaseEnded-Notification")
}

// https://stackoverflow.com/a/7080925
class CustomUIWindow: UIWindow {
    override func sendEvent(_ event: UIEvent) {
        super.sendEvent(event)
        
        switch event.type {
        case .touches:
            if let touch = event.touches(for: self)?.first {
                switch touch.phase {
                case .began:
                    NotificationCenter.default.post(name: .touchPhaseBegan, object: event)
                case .moved:
                    NotificationCenter.default.post(name: .touchPhaseMoved, object: event)
                case .ended:
                    NotificationCenter.default.post(name: .touchPhaseEnded, object: event)
                case .cancelled:
                    NotificationCenter.default.post(name: .touchPhaseEnded, object: event)
                default:
                    break
                }
            }
        default:
            break
        }
    }
}

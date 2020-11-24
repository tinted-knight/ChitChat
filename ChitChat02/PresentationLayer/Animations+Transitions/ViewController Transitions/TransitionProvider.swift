//
//  TransitionProvider.swift
//  ChitChat02
//
//  Created by Timun on 24.11.2020.
//  Copyright © 2020 TimunInc. All rights reserved.
//

import Foundation
import UIKit

protocol IViewControllerTransition: UIViewControllerAnimatedTransitioning {
    var presenting: Bool { get set }
}

protocol ITransitionProvider {
    var presentTransition: IViewControllerTransition { get }
    var pushTransition: IViewControllerTransition { get }
}

class TransitionProvider: ITransitionProvider {
    lazy var presentTransition: IViewControllerTransition = TopLeftRightBottom()
    lazy var pushTransition: IViewControllerTransition = RotatingCard()
}

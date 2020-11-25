//
//  IViewControllerTransition.swift
//  ChitChat02
//
//  Created by Timun on 25.11.2020.
//  Copyright © 2020 TimunInc. All rights reserved.
//

import Foundation
import UIKit

protocol IViewControllerTransition: UIViewControllerAnimatedTransitioning {
    var presenting: Bool { get set }
}

protocol ITransitionProvider: UIViewControllerTransitioningDelegate, UINavigationControllerDelegate {
}

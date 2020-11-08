//
//  PresentationAssembly.swift
//  ChitChat02
//
//  Created by Timun on 08.11.2020.
//  Copyright © 2020 TimunInc. All rights reserved.
//

import Foundation
import UIKit

protocol IPresentationAssembly {
    func navigationViewController(withRoot root: UIViewController) -> UINavigationController

    func channelsViewController() -> ChannelsViewController
}

class PresentationAssembly: IPresentationAssembly {
    private let serviceAssembly: IServiceAssembly
    
    init(serviceAssembly: IServiceAssembly) {
        self.serviceAssembly = serviceAssembly
    }
    
    func navigationViewController(withRoot root: UIViewController) -> UINavigationController {
        let controller = UINavigationController()
        controller.viewControllers = [root]
        return controller
    }
    
    func channelsViewController() -> ChannelsViewController {
        guard let controller = ChannelsViewController.instance() else {
            fatalError("Cannot instantiate ChannelsViewController")
        }
//        controller.channelsManager = serviceAssembly.channelService
        controller.channelModel = getChannelModel()
        return controller
    }
    
    private func getChannelModel() -> IChannelModel {
        return ChannelModel(channelService: serviceAssembly.channelService)
    }
}

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
    
    func messagesViewController(for channel: ChannelEntity) -> MessagesViewController
    
    func profileViewController() -> ProfileViewController
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
        controller.myDataModel = getFirestoreUser
        controller.themeModel = themeModel
        controller.presentationAssembly = self
        return controller
    }
    
    func messagesViewController(for channel: ChannelEntity) -> MessagesViewController {
        guard let controller = MessagesViewController.instance() else {
            fatalError("Cannot instantiate MessagesViewController")
        }
//        controller.messageModel = serviceAssembly.messageService(for: channel, userData: userData)
        controller.messageModel = getMessagesModel(for: channel)
        return controller
    }
    
    func profileViewController() -> ProfileViewController {
        guard let controller = ProfileViewController.instance() else {
            fatalError("Cannot instantiate ProfileViewController")
        }
        Log.arch("present ProfileVC")
        controller.model = getProfileModel
        return controller
    }
    
    lazy var getFirestoreUser: IFirestoreUser = {
        return FirestoreUser(userDataService: serviceAssembly.userDataService)
    }()

    private func getMessagesModel(for channel: ChannelEntity) -> IMessagesModel {
        return MessagesModel(messagesService: serviceAssembly.messageService(for: channel, userData: getFirestoreUser))
    }
    
    private func getChannelModel() -> IChannelModel {
        return ChannelModel(channelService: serviceAssembly.channelService)
    }
    
    lazy var themeModel: IThemeModelNew = {
        return ThemeModelNew(themeService: self.serviceAssembly.themeService)
    }()
    
    lazy var getProfileModel: IProfileModel = {
        return ProfileModel(dataManager: self.serviceAssembly.profileDataManager,
                            firestoreUserService: self.serviceAssembly.userDataService)
    }()
}

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
    
    func themesViewController() -> ThemesViewController
    
    func avatarCollectionViewController(_ delegate: AvatarCollectionDelegate) -> AvatarCollectionViewController
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
        let controller = ChannelsViewController(presentationAssembly: self,
                                                channelModel: getChannelModel(),
                                                myDataModel: getFirestoreUser,
                                                themeModel: getThemeModel,
                                                nibName: "ChannelsViewController",
                                                bundle: nil)
        return controller
    }
    
    func messagesViewController(for channel: ChannelEntity) -> MessagesViewController {
        guard let controller = MessagesViewController.instance() else {
            fatalError("Cannot instantiate MessagesViewController")
        }
        controller.messageModel = getMessagesModel(for: channel)
        controller.themeModel = getThemeModel
        return controller
    }
    
    func profileViewController() -> ProfileViewController {
        guard let controller = ProfileViewController.instance() else {
            fatalError("Cannot instantiate ProfileViewController")
        }
        Log.arch("present ProfileVC")
        controller.model = getProfileModel
        controller.themeModel = getThemeModel
        controller.presentationAssembly = self
        return controller
    }
    
    func themesViewController() -> ThemesViewController {
        guard let controller = ThemesViewController.instance() else {
            fatalError("Cannot instantiate ThemesViewController")
        }
        controller.themeModel = getThemeModel
        return controller
    }
    
    func avatarCollectionViewController(_ delegate: AvatarCollectionDelegate) -> AvatarCollectionViewController {
        let controller = AvatarCollectionViewController(getAvatarListModel(), delegate: delegate)
        
        return controller
    }
    
    lazy var getFirestoreUser: IFirestoreUser = {
        return FirestoreUser(userDataService: serviceAssembly.userDataService)
    }()

    private func getMessagesModel(for channel: ChannelEntity) -> IMessagesModel {
        return MessagesModel(messagesService: serviceAssembly.messageService(for: channel, userData: getFirestoreUser),
                             firestoreUser: getFirestoreUser)
    }
    
    private func getChannelModel() -> IChannelModel {
        return ChannelModel(channelService: serviceAssembly.channelService)
    }
    
    lazy var getThemeModel: IThemeModel = {
        return ThemeModel(themeService: self.serviceAssembly.themeService)
    }()
    
    lazy var getProfileModel: IProfileModel = {
        return ProfileModel(dataManager: self.serviceAssembly.profileDataManager,
                            firestoreUserService: self.serviceAssembly.userDataService)
    }()
    
    private func getAvatarListModel() -> IAvatarListModel {
        return AvatarListModel(with: serviceAssembly.avatarService)
    }
}

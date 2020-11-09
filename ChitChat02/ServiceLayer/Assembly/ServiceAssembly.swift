//
//  ServiceAssembly.swift
//  ChitChat02
//
//  Created by Timun on 08.11.2020.
//  Copyright © 2020 TimunInc. All rights reserved.
//

import Foundation

protocol IServiceAssembly {
    var channelService: IChannelService { get }
    
    var userDataService: IUserDataService { get }
    
    var themeService: IThemeService { get }
    
    var profileDataManager: IDataManagerService { get }
    
    func messageService(for channel: ChannelEntity, userData: IUserDataModel) -> IMessageService
}

class ServiceAssembly: IServiceAssembly {
    private let coreAssembly: ICoreAssembly
    
    init(coreAssembly: ICoreAssembly) {
        self.coreAssembly = coreAssembly
    }
    
    lazy var channelService: IChannelService = ChannelService(local: self.coreAssembly.cache,
                                                              remote: self.coreAssembly.remoteChannelStorage)
    
    lazy var userDataService: IUserDataService = UserDataService(storage: self.coreAssembly.keyValueStorage)
    
    lazy var themeService: IThemeService = ThemeService(storage: self.coreAssembly.keyValueStorage)
    
    lazy var profileDataManager: IDataManagerService = SmartDataManagerService(gcdManager: self.coreAssembly.gcdDataManager,
                                                                               operationManager: self.coreAssembly.operationDataManager)
    
    func messageService(for channel: ChannelEntity, userData: IUserDataModel) -> IMessageService {
        return MessageService(for: channel,
                              me: userData,
                              local: self.coreAssembly.cache,
                              remote: self.coreAssembly.remoteMessageStorage(for: channel))
    }
}

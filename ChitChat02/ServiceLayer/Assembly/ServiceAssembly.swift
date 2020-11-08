//
//  ServiceAssembly.swift
//  ChitChat02
//
//  Created by Timun on 08.11.2020.
//  Copyright © 2020 TimunInc. All rights reserved.
//

import Foundation

protocol IServiceAssembly {
    var channelService: ChannelManager { get }
}

class ServiceAssembly: IServiceAssembly {
    private let coreAssembly: ICoreAssembly
    
    init(coreAssembly: ICoreAssembly) {
        self.coreAssembly = coreAssembly
    }
    
    lazy var channelService: ChannelManager = SmartChannelManager(self.coreAssembly.storage)
}

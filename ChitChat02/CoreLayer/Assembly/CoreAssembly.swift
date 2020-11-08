//
//  CoreAssembly.swift
//  ChitChat02
//
//  Created by Timun on 08.11.2020.
//  Copyright © 2020 TimunInc. All rights reserved.
//

import Foundation

protocol ICoreAssembly {
    var cache: IStorage { get }

    var remoteChannelStorage: IRemoteChannelStorage { get }

    var keyValueStorage: IKeyValueStorage { get }

    func remoteMessageStorage(for channel: ChannelEntity) -> IRemoteMessageStorage
}

class CoreAssembly: ICoreAssembly {
    lazy var cache: IStorage = NewSchoolStorage()
    
    lazy var remoteChannelStorage: IRemoteChannelStorage = RemoteChannelStorage()

    lazy var keyValueStorage: IKeyValueStorage = KeyValueStorage()

    func remoteMessageStorage(for channel: ChannelEntity) -> IRemoteMessageStorage {
        return RemoteMessageStorage(for: channel)
    }
}

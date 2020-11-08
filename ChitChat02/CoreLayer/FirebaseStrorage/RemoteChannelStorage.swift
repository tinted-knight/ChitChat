//
//  RemoteChannelStorage.swift
//  ChitChat02
//
//  Created by Timun on 08.11.2020.
//  Copyright © 2020 TimunInc. All rights reserved.
//

import Foundation

protocol IRemoteChannelStorage {
    func loadChannelList(onAdded: @escaping (Channel) -> Void,
                         onModified: @escaping (Channel) -> Void,
                         onRemoved: @escaping (Channel) -> Void,
                         onError: @escaping (String) -> Void)
    func loadOnce(onData: @escaping ([Channel]) -> Void)
    func addChannel(name: String, completion: @escaping (Bool) -> Void)
    func deleteChannel(id: String, completion: @escaping (Bool) -> Void)
}

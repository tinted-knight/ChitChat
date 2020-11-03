//
//  protocols.swift
//  ChitChat02
//
//  Created by Timun on 17.10.2020.
//  Copyright © 2020 TimunInc. All rights reserved.
//

import Foundation
import CoreData
import Firebase

protocol RemoteChannelManager {
    func loadChannelList(onAdded: @escaping ([Channel]) -> Void,
                         onModified: @escaping (Channel) -> Void,
                         onRemoved: @escaping (Channel) -> Void,
                         onError: @escaping (String) -> Void)
    func addChannel(name: String, completion: @escaping (Bool) -> Void)
    func deleteChannel(id: String, completion: @escaping (Bool) -> Void)
}

protocol ChannelManager {
    var frc: NSFetchedResultsController<ChannelEntity> { get }
    
    func fetchRemote()
    func addChannel(name: String)
    func deleteChannel(_ channel: ChannelEntity)
}

protocol MessageManager {
    var channel: ChannelEntity { get }
    var frc: NSFetchedResultsController<MessageEntity> { get }
    
    func fetchRemote(completion: @escaping () -> Void)
    func add(message content: String)
}

protocol RemoteMessageManager {
    func loadMessageList(onAdded: @escaping ([Message]) -> Void,
                         onModified: @escaping ([Message]) -> Void,
                         onRemoved: @escaping ([Message]) -> Void,
                         onError: @escaping (String) -> Void)
    func add(data: [String: Any], completion: @escaping (Bool) -> Void)
}

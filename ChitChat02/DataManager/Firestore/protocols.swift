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

protocol ChannelsManager {
    func loadChannelList(onAdded: @escaping (Channel) -> Void,
                         onModified: @escaping (Channel) -> Void,
                         onRemoved: @escaping (Channel) -> Void,
                         onError: @escaping (String) -> Void)
    func loadChannelList(onData: @escaping ([Channel]) -> Void, onError: @escaping (String) -> Void)
    func getChannel(id channelId: String, onData: @escaping (Channel) -> Void, onError: @escaping (String) -> Void)
    func addChannel(name: String, completion: @escaping (Bool) -> Void)
    func deleteChannel(id: String, completion: @escaping (Bool) -> Void)
}

protocol NewChannelManager {
    var frc: NSFetchedResultsController<ChannelEntity> { get }
    
    func fetchRemote()
    func addChannel(name: String)
    func deleteChannel(_ channel: ChannelEntity)
}

protocol NewMessageManager {
    var channel: ChannelEntity { get }
    var frc: NSFetchedResultsController<MessageEntity> { get }
    func fetchRemote(completion: @escaping () -> Void)
    func add(message content: String)
}

protocol MessagesReader {
    func loadMessageList(onData: @escaping ([Message]) -> Void, onError: @escaping (String) -> Void)
}

protocol MessagesManager: MessagesReader {
    var frc: NSFetchedResultsController<MessageEntity> { get }
    func add(data: [String: Any], completion: @escaping (Bool) -> Void)
}

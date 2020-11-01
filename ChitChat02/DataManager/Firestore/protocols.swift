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
    func loadChannelList(onData: @escaping ([Channel]) -> Void, onError: @escaping (String) -> Void)
    func getChannel(id channelId: String, onData: @escaping (Channel) -> Void, onError: @escaping (String) -> Void)
    func addChannel(name: String, completion: @escaping (Bool) -> Void)
    func deleteChannel(id: String, completion: @escaping (Bool) -> Void)
}

protocol NewChannelManager {
    var frc: NSFetchedResultsController<ChannelEntity> { get }
    
    func fetchRemote()
    func addChannel(name: String)
}

protocol MessagesReader {
    func loadMessageList(onData: @escaping ([Message]) -> Void, onError: @escaping (String) -> Void)
}

protocol MessagesManager: MessagesReader {
    var frc: NSFetchedResultsController<MessageEntity> { get }
    func add(message: String, completion: @escaping () -> Void)
}

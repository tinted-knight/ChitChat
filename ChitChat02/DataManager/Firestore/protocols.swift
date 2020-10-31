//
//  protocols.swift
//  ChitChat02
//
//  Created by Timun on 17.10.2020.
//  Copyright © 2020 TimunInc. All rights reserved.
//

import Foundation
import CoreData

protocol ChannelsManager {
    func loadChannelList(onData: @escaping ([Channel]) -> Void, onError: @escaping (String) -> Void)
    func addChannel(name: String)
}

protocol MessagesReader {
    func loadMessageList(onData: @escaping ([Message]) -> Void, onError: @escaping (String) -> Void)
}

protocol MessagesManager: MessagesReader {
    var frc: NSFetchedResultsController<MessageEntity> { get }
    func add(message: String)
}

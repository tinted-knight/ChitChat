//
//  CoreDataManager.swift
//  ChitChat02
//
//  Created by Timun on 23.10.2020.
//  Copyright © 2020 TimunInc. All rights reserved.
//

import Foundation

class CoreDataManager {
    private let coreDataStack: CoreDataStack
    private let channelsManager: ChannelsManager
    
    init(coreDataStack: CoreDataStack, channelsManager: ChannelsManager) {
        self.coreDataStack = coreDataStack
        self.channelsManager = channelsManager
    }
    
    func checkSavedData(_ completion: @escaping ([ChannelEntity: [MessageEntity]]) -> Void) {
        coreDataStack.load(completion)
    }
    
    func loadFromNetAndSaveLocally() {
        channelsManager.loadChannelList(onData: { [weak self] (channels) in
            guard let self = self else { return }
            
            channels.forEach { (channel) in
                let messagesReader = FirestoreMessageReader(for: channel)
                messagesReader.loadMessageList(onData: { (messages) in
                    Log.oldschool("Channel from net: \(channel.name); message count: \(messages.count)")
                    messages.forEach { Log.oldschool("        \($0.content)") }
                    self.save(channel, with: messages)
                }, onError: { error in
                    fatalError(error)
                })
            }
        }, onError: { (error) in
            fatalError(error)
        })
    }
    
    private func save(_ channel: Channel, with messages: [Message]) {
        coreDataStack.performSave { (context) in
            let channelEntity = ChannelEntity(from: channel, in: context)
            let messageEntityList = messages.map { MessageEntity(from: $0, in: context) }
            channelEntity.addToMessages(NSSet(array: messageEntityList))
        }
    }
}

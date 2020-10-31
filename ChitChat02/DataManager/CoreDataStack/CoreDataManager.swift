//
//  CoreDataManager.swift
//  ChitChat02
//
//  Created by Timun on 23.10.2020.
//  Copyright © 2020 TimunInc. All rights reserved.
//

import Foundation
import CoreData

class CoreDataManager {
    private let coreDataStack: CoreDataStack
    private let channelsManager: ChannelsManager

    init(coreDataStack: CoreDataStack, channelsManager: ChannelsManager) {
        self.coreDataStack = coreDataStack
        self.channelsManager = channelsManager

//        coreDataStack.didUpdateDatabase = { $0.printDBStat() }
//        coreDataStack.enableObservers()
    }
    
    lazy var frcChannels: NSFetchedResultsController<ChannelEntity> = {
        let sortChannels = NSSortDescriptor(key: "name", ascending: true)
        let frChannels = NSFetchRequest<ChannelEntity>(entityName: "ChannelEntity")
        frChannels.sortDescriptors = [sortChannels]
        
        return NSFetchedResultsController(fetchRequest: frChannels,
                                          managedObjectContext: coreDataStack.mainContext,
                                          sectionNameKeyPath: nil,
                                          cacheName: nil)
    }()
    
    func frcMess(for channelId: String) -> NSFetchedResultsController<MessageEntity> {
        Log.oldschool("frcMess for \(channelId)")
        let sortMessages = NSSortDescriptor(key: "documentId", ascending: true)
        let predicate = NSPredicate(format: "channel.identifier like '\(channelId)'")

        let frMessages = NSFetchRequest<MessageEntity>(entityName: "MessageEntity")
        frMessages.sortDescriptors = [sortMessages]
        frMessages.predicate = predicate

        return NSFetchedResultsController(fetchRequest: frMessages,
                                          managedObjectContext: coreDataStack.mainContext,
                                          sectionNameKeyPath: nil,
                                          cacheName: nil)
    }
    
    func fetchMessagesFor(channel: ChannelEntity) {
        //
    }
    
    func checkSavedData(_ completion: @escaping ([ChannelEntity: [MessageEntity]]) -> Void) {
        coreDataStack.load(completion)
    }
    
    func loadFromNetAndSaveLocally() {
        channelsManager.loadChannelList(onData: { [weak self] (channels) in
            Log.oldschool("fire channels \(channels.count)")
            guard let self = self else { return }
            
            channels.forEach { (channel) in
                let messagesReader = FirestoreMessageReader(for: channel)
                messagesReader.loadMessageList(onData: { (messages) in
                    Log.oldschool("fire messages for <\(channel.name)>, \(messages.count)")
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

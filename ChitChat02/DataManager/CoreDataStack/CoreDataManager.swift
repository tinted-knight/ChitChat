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
    let coreDataStack: CoreDataStack
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
    
//    func checkSavedData(_ completion: @escaping ([ChannelEntity: [MessageEntity]]) -> Void) {
//        coreDataStack.load(completion)
//    }

    func refreshChannels() {
        Log.oldschool(#function)
        channelsManager.loadChannelList(onData: { [weak self] (channels) in
            Log.oldschool("fire channels \(channels.count)")
            guard let self = self else { return }
            
            channels.forEach { (channel) in
                self.coreDataStack.performSave { (context) in
                    ChannelEntity(from: channel, in: context)
                }
            }
            }, onError: { (error) in
                fatalError(error)
        })
    }

    func refresh(_ channel: ChannelEntity) {
        Log.oldschool(#function)
        channelsManager.getChannel(id: channel.identifier, onData: { [weak self] (channel) in
            let messagesReader = FirestoreMessageReader(for: channel.identifier)
            messagesReader.loadMessageList(onData: { (values) in
                Log.oldschool("refresh, \(channel.name), \(values.count) messages")
                self?.save(channel, with: values)
            }, onError: { Log.oldschool($0)})
        }, onError: { Log.oldschool($0) })
    }
    
    func delete(channel: ChannelEntity) {
        channelsManager.deleteChannel(id: channel.identifier) { [weak self] (result) in
            if result {
                self?.coreDataStack.delete(channel)
                self?.refreshChannels()
            }
        }
    }
    
//    func loadFromNetAndSaveLocally() {
//        channelsManager.loadChannelList(onData: { [weak self] (channels) in
//            Log.oldschool("fire channels \(channels.count)")
//            guard let self = self else { return }
//
//            channels.forEach { (channel) in
//                let messagesReader = FirestoreMessageReader(for: channel.identifier)
//                messagesReader.loadMessageList(onData: { (messages) in
//                    Log.oldschool("fire messages for <\(channel.name)>, \(messages.count)")
//                    self.save(channel, with: messages)
//                }, onError: { error in
//                    fatalError(error)
//                })
//            }
//        }, onError: { (error) in
//            fatalError(error)
//        })
//    }
    
    private func save(_ channel: Channel, with messages: [Message]) {
        coreDataStack.performSave { (context) in
            let channelEntity = ChannelEntity(from: channel, in: context)
            let messageEntityList = messages.map { MessageEntity(from: $0, in: context) }
            channelEntity.addToMessages(NSSet(array: messageEntityList))
        }
    }
}
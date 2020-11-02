//
//  SmartChannelManager.swift
//  ChitChat02
//
//  Created by Timun on 01.11.2020.
//  Copyright © 2020 TimunInc. All rights reserved.
//

import Foundation
import CoreData

class LocalCache {
    let container: NSPersistentContainer
    
    init(_ container: NSPersistentContainer) {
        self.container = container
    }
    
//    func performSave(block: @escaping (NSManagedObjectContext) -> Void) {
//        container.performBackgroundTask { (context) in
//            block(context)
//            if context.hasChanges {
//                do {
//                    try context.obtainPermanentIDs(for: Array(context.insertedObjects))
//                    try context.save()
//                } catch {
//                    Log.newschool(error.localizedDescription)
//                }
//            }
//        }
//    }
    
    func saveContext() {
        if container.viewContext.hasChanges {
            do {
                try container.viewContext.obtainPermanentIDs(for: Array(container.viewContext.insertedObjects))
                try container.viewContext.save()
            } catch {
                Log.newschool(error.localizedDescription)
            }
        }
    }
    
    func performDelete() {
        do {
            try container.viewContext.save()
        } catch {
            fatalError("cannot delete with viewContext")
        }
    }
}

class SmartChannelManager: NewChannelManager {
    private let cache: LocalCache
    private let channelsManager: ChannelsManager
    private let viewContext: NSManagedObjectContext

    init(_ container: NSPersistentContainer) {
        self.cache = LocalCache(container)
        self.viewContext = cache.container.viewContext
        self.channelsManager = FirestoreChannelManager(with: viewContext)
    }

    lazy var frc: NSFetchedResultsController<ChannelEntity> = {
        let sortChannels = NSSortDescriptor(key: "name", ascending: true)
        let frChannels = NSFetchRequest<ChannelEntity>(entityName: "ChannelEntity")
        frChannels.sortDescriptors = [sortChannels]
        
        return NSFetchedResultsController(fetchRequest: frChannels,
                                          managedObjectContext: self.viewContext,
                                          sectionNameKeyPath: nil,
                                          cacheName: nil)
    }()
    
    func fetchRemote() {
        channelsManager.loadChannelList(onAdded: { [weak self] (channel) in
            guard let context = self?.viewContext, let cache = self?.cache else { return }
            Log.newschool("fetchRemote channels, added \(channel.name), \(channel.lastMessage)")
            context.insert(ChannelEntity(from: channel, in: context))
            cache.saveContext()
        }, onModified: { [weak self] (channel) in
            guard let context = self?.viewContext, let cache = self?.cache else { return }
            Log.newschool("fetchRemote channels, modified \(channel.name), \(channel.lastMessage)")
            
            let request: NSFetchRequest<ChannelEntity> = ChannelEntity.fetchRequest()
            request.predicate = NSPredicate(format: "identifier == %@", channel.identifier)
            request.fetchLimit = 1
            do {
                let toUpdate = try context.fetch(request)
                if !toUpdate.isEmpty {
                    Log.newschool("updating channel \(toUpdate[0].name)")
                    toUpdate[0].lastMessage = channel.lastMessage
                    toUpdate[0].lastActivity = channel.lastActivity
                    cache.saveContext()
                }
            } catch { fatalError("cannot fetch channel for update") }
            
            context.insert(ChannelEntity(from: channel, in: context))
            cache.saveContext()
        }, onRemoved: { [weak self] (channel) in
            guard let context = self?.viewContext, let cache = self?.cache else { return }
            Log.newschool("fetchRemote channels, removed \(channel.name)")
            
            let request: NSFetchRequest<ChannelEntity> = ChannelEntity.fetchRequest()
            request.predicate = NSPredicate(format: "identifier == %@", channel.identifier)
            request.fetchLimit = 1
            do {
                let sacrifice = try context.fetch(request)
                if !sacrifice.isEmpty {
                    Log.newschool("deleting channel \(sacrifice[0].name)")
                    context.delete(sacrifice[0])
                    cache.performDelete()
                }
            } catch { fatalError("cannot fetch channel for deletion") }
        }, onError: onError(_:))
//        channelsManager.loadChannelList(onData: { [weak self] (values) in
//            guard let self = self else { fatalError("fetchRemote::no self") }
//            Log.newschool("fetchRemote, \(values.count) channels")
//            values.forEach { (channel) in
//                self.viewContext.insert(ChannelEntity(from: channel, in: self.viewContext))
//                self.cache.saveContext()
//            }
//        }, onError: onError(_:))
    }
    
    func addChannel(name: String) {
        channelsManager.addChannel(name: name) { [weak self] (success) in
            if success { Log.newschool("add channel sucess") }
//            if success { self?.fetchRemote() }
        }
    }
    
    func deleteChannel(_ channel: ChannelEntity) {
        channelsManager.deleteChannel(id: channel.identifier) { [weak self] (success) in
            if success { Log.newschool("delete channel sucess") }
//            if success { self?.fetchRemote() }
        }
    }
    
    private func onError(_ message: String) {
        Log.newschool(message)
    }
}

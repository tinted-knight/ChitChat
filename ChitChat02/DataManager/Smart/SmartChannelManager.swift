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
        channelsManager.loadChannelList(
            onAdded: { [weak self] (channel) in
                Log.newschool("fetchRemote channels, added \(channel.name), \(channel.lastMessage ?? "")")
                self?.insertChannel(channel)
            }, onModified: { [weak self] (channel) in
                Log.newschool("fetchRemote channels, modified \(channel.name), \(channel.lastMessage ?? "")")
                self?.updateChannel(with: channel.identifier, message: channel.lastMessage, activity: channel.lastActivity)
            }, onRemoved: { [weak self] (channel) in
                Log.newschool("fetchRemote channels, removed \(channel.name)")
                self?.deleteFromDB(with: channel.identifier)
            }, onError: onError(_:))
    }
    
    func addChannel(name: String) {
        channelsManager.addChannel(name: name) { (success) in
            Log.newschool("add channel \(success)")
        }
    }
    
    func deleteChannel(_ channel: ChannelEntity) {
        channelsManager.deleteChannel(id: channel.identifier) { (success) in
            Log.newschool("delete channel \(success)")
        }
    }
    
    private func deleteFromDB(with identifier: String) {
        let request: NSFetchRequest<ChannelEntity> = ChannelEntity.fetchRequest()
        request.predicate = NSPredicate(format: "identifier == %@", identifier)
        request.fetchLimit = 1
        do {
            let sacrifice = try viewContext.fetch(request)
            if !sacrifice.isEmpty {
                Log.newschool("deleting channel \(sacrifice[0].name)")
                viewContext.delete(sacrifice[0])
                cache.performDelete()
            }
        } catch { fatalError("cannot fetch channel for deletion") }
    }
    
    private func insertChannel(_ channel: Channel) {
        viewContext.insert(ChannelEntity(from: channel, in: viewContext))
        cache.saveContext()
    }
    
    private func updateChannel(with identifier: String, message: String?, activity: Date?) {
        let request: NSFetchRequest<ChannelEntity> = ChannelEntity.fetchRequest()
        request.predicate = NSPredicate(format: "identifier == %@", identifier)
        request.fetchLimit = 1
        do {
            let toUpdate = try viewContext.fetch(request)
            if !toUpdate.isEmpty {
                Log.newschool("updating channel \(toUpdate[0].name)")
                toUpdate[0].lastMessage = message
                toUpdate[0].lastActivity = activity
                cache.saveContext()
            }
        } catch { fatalError("cannot fetch channel for update") }
    }
    
    private func onError(_ message: String) {
        Log.newschool(message)
    }
}

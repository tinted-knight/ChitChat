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
                try container.viewContext.save()
            } catch {
                Log.newschool(error.localizedDescription)
            }
        }
    }
}

class SuperSmartChannelManager: NewChannelManager {
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
        channelsManager.loadChannelList(onData: { [weak self] (values) in
            guard let self = self else { fatalError("fetchRemote::no self") }
            values.forEach { (channel) in
                self.viewContext.insert(ChannelEntity(from: channel))
                self.cache.saveContext()
            }
        }, onError: onError(_:))
    }
    
    private func onError(_ message: String) {
        Log.newschool(message)
    }
}

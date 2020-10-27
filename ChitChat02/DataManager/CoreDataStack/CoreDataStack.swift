//
//  CoreDataStack\.swift
//  ChitChat02
//
//  Created by Timun on 23.10.2020.
//  Copyright © 2020 TimunInc. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    
    var didUpdateDatabase: ((CoreDataStack) -> Void)?
    
    private var storeUrl: URL = {
        guard let documents = FileManager
            .default.urls(for: .documentDirectory, in: .userDomainMask).last else {
                fatalError("document path not found")
        }
        return documents.appendingPathComponent("Chat.sqlite")
    }()
    
    private let dataModelName = "Chat"
    private let dataModelExtension = "momd"
    
    private(set) lazy var managedObjectModel: NSManagedObjectModel = {
        guard let modelUrl = Bundle
            .main.url(forResource: self.dataModelName, withExtension: self.dataModelExtension) else {
                fatalError("model not found")
        }
        
        guard let managedObjectModel = NSManagedObjectModel(contentsOf: modelUrl) else {
            fatalError("managedObjectModel could not be created")
        }
        
        return managedObjectModel
    }()
    
    private lazy var coordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        
        do {
            // в отдельную очередь
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType,
                                               configurationName: nil,
                                               at: self.storeUrl,
                                               options: nil)
        } catch {
            fatalError(error.localizedDescription)
        }
        return coordinator
    }()
    
    private lazy var writerContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.persistentStoreCoordinator = self.coordinator
        context.mergePolicy = NSOverwriteMergePolicy
        return context
    }()
    
    private lazy var mainContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.parent = self.writerContext
        context.automaticallyMergesChangesFromParent = true
        context.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
        return context
    }()
    
    private func saveContext() -> NSManagedObjectContext {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.parent = self.mainContext
        context.automaticallyMergesChangesFromParent = true
        context.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
        return context
    }
}
// MARK: Load
extension CoreDataStack {
    func load(_ completion: @escaping ([ChannelEntity: [MessageEntity]]) -> Void) {
        mainContext.perform {
            do {
                let channels = try self.mainContext.fetch(ChannelEntity.fetchRequest()) as? [ChannelEntity] ?? []
                Log.oldschool("channels loaded: \(channels.count)")
                let messages = try self.mainContext.fetch(MessageEntity.fetchRequest()) as? [MessageEntity] ?? []
                Log.oldschool("messages loaded: \(messages.count)")
                var result: [ChannelEntity: [MessageEntity]] = [:]
                channels.forEach { (channel) in
                    let filtered = messages.filter { $0.channel.identifier == channel.identifier }
                    result[channel] = filtered
                }
                completion(result)
            } catch {
                fatalError(error.localizedDescription)
            }
        }
    }
}
// MARK: Save
extension CoreDataStack {
    func performSave(_ block: (NSManagedObjectContext) -> Void) {
        let context = saveContext()
        context.performAndWait {
            block(context)
            if context.hasChanges {
                do {
                    try performSave(in: context)
                } catch {
                    assertionFailure(error.localizedDescription)
                }
            }
        }
    }
    
    private func performSave(in context: NSManagedObjectContext) throws {
        // эта обёртка убирает runtime error EXC_BAD_INSTRUCTION (code=EXC_I386_INVOP, subcode=0x0)
//        context.perform {
//            do {
                try context.save()
//            } catch {
//                assertionFailure(error.localizedDescription)
//            }
//        }
        if let parent = context.parent { try performSave(in: parent)}
    }
}
// MARK: Logs
extension CoreDataStack {
    func enableObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(contextDidChange(notification:)),
            name: NSNotification.Name.NSManagedObjectContextObjectsDidChange,
            object: mainContext
        )
    }
    
    @objc private func contextDidChange(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        
        didUpdateDatabase?(self)
        
        if let inserts = userInfo[NSInsertedObjectsKey] as? Set<NSManagedObject>,
            inserts.count > 0 {
            Log.oldschool("Added objects: \(inserts.count)")
        }
        
        if let updates = userInfo[NSUpdatedObjectsKey] as? Set<NSManagedObject>,
            updates.count > 0 {
            Log.oldschool("Updated objects: \(updates.count)")
        }
        
        if let deletes = userInfo[NSDeletedObjectsKey] as? Set<NSManagedObject>,
            deletes.count > 0 {
            Log.oldschool("Deleted objects: \(deletes.count)")
        }
    }
    
    func printDBStat() {
        mainContext.perform {
            do {
                let count = try self.mainContext.count(for: ChannelEntity.fetchRequest())
                print("\(count) channels")
                let channels = try self.mainContext.fetch(ChannelEntity.fetchRequest()) as? [ChannelEntity] ?? []
                channels.forEach {
                    print($0.name)
                }
                let messages = try self.mainContext.fetch(MessageEntity.fetchRequest()) as? [MessageEntity] ?? []
                messages.forEach {
                    print($0.content)
                }
            } catch {
                fatalError(error.localizedDescription)
            }
        }
    }
}

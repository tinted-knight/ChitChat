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
    
    lazy var mainContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.parent = self.writerContext
        context.automaticallyMergesChangesFromParent = true
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return context
    }()
    
    private func saveContext() -> NSManagedObjectContext {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.parent = self.mainContext
        context.automaticallyMergesChangesFromParent = true
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return context
    }

    private func logContext() -> NSManagedObjectContext {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.parent = self.mainContext
        context.automaticallyMergesChangesFromParent = true
        context.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
        return context
    }
}
// MARK: Load
//extension CoreDataStack {
//    func load(_ completion: @escaping ([ChannelEntity: [MessageEntity]]) -> Void) {
//        mainContext.perform {
//            do {
//                let channels = try self.mainContext.fetch(ChannelEntity.fetchRequest()) as? [ChannelEntity] ?? []
//                Log.oldschool("channels loaded: \(channels.count)")
//                let messages = try self.mainContext.fetch(MessageEntity.fetchRequest()) as? [MessageEntity] ?? []
//                Log.oldschool("messages loaded: \(messages.count)")
//                var result: [ChannelEntity: [MessageEntity]] = [:]
//                channels.forEach { (channel) in
//                    let filtered = messages.filter { $0.channel.identifier == channel.identifier }
//                    result[channel] = filtered
//                }
//                completion(result)
//            } catch {
//                fatalError(error.localizedDescription)
//            }
//        }
//    }
//}
// MARK: Save
extension CoreDataStack {
    func performSave(_ block: @escaping (NSManagedObjectContext) -> Void) {
        let context = saveContext()
        context.perform { [weak self] in
//            Log.oldschool("= isMainThread: \(Thread.isMainThread)")
            block(context)
            if context.hasChanges {
                do {
                    try context.obtainPermanentIDs(for: Array(context.insertedObjects))
                } catch {
                    Log.oldschool("obtainPermanentIDs error")
                }
                self?.performSave(in: context)
            }
        }
    }
    
    private func performSave(in context: NSManagedObjectContext) {
        context.performAndWait {
//            Log.oldschool("=|= isMainThread: \(Thread.isMainThread)")
            // вот здесь иногда выскакивает mainThread, видимо когда исполняется на mainContext
            do {
                try context.save()
                if let parent = context.parent { performSave(in: parent) }
            } catch {
                assertionFailure(error.localizedDescription)
            }
        }
    }
    
    func delete(_ channel: ChannelEntity) {
        mainContext.delete(channel)
        do {
            try mainContext.save()
        } catch {
            fatalError("cannot delete with mainContext")
        }
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
        let context = logContext()
        context.perform {
            do {
                let count = try context.count(for: ChannelEntity.fetchRequest())
                Log.delimiter("\(count) channels")
                let channels = try context.fetch(ChannelEntity.fetchRequest()) as? [ChannelEntity] ?? []
                channels.forEach {
                    print($0.name)
                }
                let messages = try context.fetch(MessageEntity.fetchRequest()) as? [MessageEntity] ?? []
                Log.delimiter("messages")
                messages.forEach {
                    print("\($0.content), \($0.documentId)")
                }
            } catch {
                fatalError(error.localizedDescription)
            }
        }
    }
}

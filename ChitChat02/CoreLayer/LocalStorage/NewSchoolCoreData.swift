//
//  NewSchool.swift
//  ChitChat02
//
//  Created by Timun on 01.11.2020.
//  Copyright © 2020 TimunInc. All rights reserved.
//

import Foundation
import CoreData

protocol IStorage {
    var viewContext: NSManagedObjectContext? { get }

    func createContainer(completion: @escaping () -> Void)
    func saveContext()
    func saveInBackground(bloc: @escaping (NSManagedObjectContext) -> Void)
    func performDelete()
}

class NewSchoolStorage: IStorage {
    private var container: NSPersistentContainer?
    
    lazy var viewContext = container?.viewContext
    
    func createContainer(completion: @escaping () -> Void) {
        let container = NSPersistentContainer(name: "Chat")
        container.loadPersistentStores(completionHandler: { [weak self] _, error in
            self?.container = container
            container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyStoreTrump
            container.viewContext.automaticallyMergesChangesFromParent = true
            guard error == nil else {
                fatalError("Failed to load store")
            }
            completion()
        })
    }

    func saveContext() {
        guard let container = container else { return }
        if container.viewContext.hasChanges {
            do {
                try container.viewContext.obtainPermanentIDs(for: Array(container.viewContext.insertedObjects))
                try container.viewContext.save()
            } catch {
                Log.newschool(error.localizedDescription)
            }
        }
    }
    
    func saveInBackground(bloc: @escaping (NSManagedObjectContext) -> Void) {
        guard let container = container else { return }
        container.performBackgroundTask { (context) in
            context.automaticallyMergesChangesFromParent = true
            context.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
            bloc(context)
            if context.hasChanges {
                do {
                    try context.obtainPermanentIDs(for: Array(context.insertedObjects))
                    try context.save()
                } catch {
                    Log.newschool("bg save error, \(error.localizedDescription)")
                }
            }
        }
    }
    
    func performDelete() {
        guard let container = container else { return }
        do {
            try container.viewContext.save()
        } catch {
            fatalError("cannot delete with viewContext")
        }
    }
}

class NewSchoolCoreData {
    
    var container: NSPersistentContainer?
    
    func createContainer(completion: @escaping (NSPersistentContainer) -> Void) {
        let container = NSPersistentContainer(name: "Chat")
        container.loadPersistentStores(completionHandler: { [weak self] _, error in
            self?.container = container
            container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyStoreTrump
            container.viewContext.automaticallyMergesChangesFromParent = true
            guard error == nil else {
                fatalError("Failed to load store")
            }
            completion(container)
        })
    }
}

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
    
    func saveInBackground(bloc: @escaping (NSManagedObjectContext) -> Void) {
        container.performBackgroundTask { (context) in
            context.automaticallyMergesChangesFromParent = true
            context.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
            bloc(context)
            if context.hasChanges {
                do {
                    try context.obtainPermanentIDs(for: Array(context.insertedObjects))
                    try context.save()
                } catch {
                    Log.newschool("bg save error, \(error.localizedDescription)")
                }
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

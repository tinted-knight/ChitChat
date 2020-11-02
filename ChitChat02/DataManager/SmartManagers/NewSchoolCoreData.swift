//
//  NewSchool.swift
//  ChitChat02
//
//  Created by Timun on 01.11.2020.
//  Copyright © 2020 TimunInc. All rights reserved.
//

import Foundation
import CoreData

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
    
    func performDelete() {
        do {
            try container.viewContext.save()
        } catch {
            fatalError("cannot delete with viewContext")
        }
    }
}

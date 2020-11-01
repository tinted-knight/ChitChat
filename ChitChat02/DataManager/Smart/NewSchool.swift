//
//  NewSchool.swift
//  ChitChat02
//
//  Created by Timun on 01.11.2020.
//  Copyright © 2020 TimunInc. All rights reserved.
//

import Foundation
import CoreData

class NewSchool {
    
    var container: NSPersistentContainer?
    
    func createContainer(completion: @escaping (NSPersistentContainer) -> Void) {
        let container = NSPersistentContainer(name: "Chat")
        container.loadPersistentStores(completionHandler: { _, error in
            container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyStoreTrump
//            container.viewContext.mergePolicy = NSOverwriteMergePolicy
            guard error == nil else {
                fatalError("Failed to load store")
            }
            completion(container)
        })
    }
}

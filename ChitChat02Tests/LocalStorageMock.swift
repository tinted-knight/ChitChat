//
//  ChannelServiceMock.swift
//  ChitChat02Tests
//
//  Created by Timun on 28.11.2020.
//  Copyright © 2020 TimunInc. All rights reserved.
//

@testable import ChitChat02
import Foundation
import CoreData

class LocalStorageMock: IStorage {
    var viewContext: NSManagedObjectContext?

    var createContainerCalls = 0
    
    var saveContextCalls = 0
    
    var performDeleteCalls = 0
    
    var saveInBackgroundCalls = 0

    func createContainer(completion: @escaping () -> Void) {
        createContainerCalls += 1
    }

    func saveContext() {
        saveContextCalls += 1
    }
    
    func saveInBackground(bloc: @escaping (NSManagedObjectContext) -> Void) {
        saveInBackgroundCalls += 1
    }
    
    func performDelete() {
        performDeleteCalls += 1
    }
}

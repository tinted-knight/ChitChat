//
// Created by Timun on 02.11.2020.
// Copyright (c) 2020 TimunInc. All rights reserved.
//

import Foundation
import CoreData

class SmartMessageManager: NewMessageManager {

    private let cache: LocalCache
    private let messagesManager: MessagesManager
    private let viewContext: NSManagedObjectContext
    private let channelId: String

    init(for channel: ChannelEntity, me userData: UserData, container: NSPersistentContainer) {
        self.cache = LocalCache(container)
        self.viewContext = cache.container.viewContext
        self.channelId = channel.identifier
        self.messagesManager = FirestoreMessageManager(for: channel, me: userData, with: viewContext)
    }

    lazy var frc: NSFetchedResultsController<MessageEntity> = {
        let sortMessages = NSSortDescriptor(key: "created", ascending: false)
        let predicate = NSPredicate(format: "channel.identifier like '\(channelId)'")

        let frMessages = NSFetchRequest<MessageEntity>(entityName: "MessageEntity")
        frMessages.sortDescriptors = [sortMessages]
        frMessages.predicate = predicate

        return NSFetchedResultsController(fetchRequest: frMessages,
                managedObjectContext: self.viewContext,
                sectionNameKeyPath: nil,
                cacheName: nil)
    }()
}

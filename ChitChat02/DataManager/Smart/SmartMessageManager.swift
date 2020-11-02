//
// Created by Timun on 02.11.2020.
// Copyright (c) 2020 TimunInc. All rights reserved.
//

import Foundation
import CoreData
import Firebase

class SmartMessageManager: NewMessageManager {

    private let cache: LocalCache
    private let messagesManager: MessagesManager
    private let viewContext: NSManagedObjectContext
    private let my: UserData
    let channel: ChannelEntity

    init(for channel: ChannelEntity, me userData: UserData, container: NSPersistentContainer) {
        self.cache = LocalCache(container)
        self.viewContext = cache.container.viewContext
        self.channel = channel
        self.my = userData
        self.messagesManager = FirestoreMessageManager(for: channel, with: viewContext)
    }

    lazy var frc: NSFetchedResultsController<MessageEntity> = {
        let sortMessages = NSSortDescriptor(key: "created", ascending: false)
        let predicate = NSPredicate(format: "channel.identifier like '\(channel.identifier)'")

        let frMessages = NSFetchRequest<MessageEntity>(entityName: "MessageEntity")
        frMessages.sortDescriptors = [sortMessages]
        frMessages.predicate = predicate

        return NSFetchedResultsController(fetchRequest: frMessages,
                managedObjectContext: self.viewContext,
                sectionNameKeyPath: nil,
                cacheName: nil)
    }()
    
    func fetchRemote(completion: @escaping () -> Void) {
        messagesManager.loadMessageList(onData: { [weak self] (values) in
            guard let self = self else { fatalError("fetchRemote::no self") }
            Log.newschool("fetchRemote, \(values.count) messages for \(self.channel.identifier)")
            let entities = values.map { MessageEntity(from: $0, in: self.viewContext) }
            self.channel.addToMessages(NSSet(array: entities))
            self.cache.saveContext()
            completion()
        }, onError: onError(_:))
    }
    
    func add(message content: String) {
        let messageData: [String: Any] = [
            Message.content: content,
            Message.created: Timestamp(date: Date()),
            Message.senderName: my.name,
            Message.senderId: my.uuid
        ]
        messagesManager.add(data: messageData) { [weak self] (success) in
            if success { self?.fetchRemote(completion: {})}
        }
    }

    private func onError(_ message: String) {
        Log.newschool(message)
    }
}

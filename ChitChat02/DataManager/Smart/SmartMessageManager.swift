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
        let predicate = NSPredicate(format: "channel.identifier == '\(channel.identifier)'")

        let frMessages = NSFetchRequest<MessageEntity>(entityName: "MessageEntity")
        frMessages.sortDescriptors = [sortMessages]
        frMessages.predicate = predicate

        return NSFetchedResultsController(fetchRequest: frMessages,
                managedObjectContext: self.viewContext,
                sectionNameKeyPath: nil,
                cacheName: nil)
    }()
    
    func fetchRemote(completion: @escaping () -> Void) {
        messagesManager.loadMessageList(
            onAdded: { [weak self] (message) in
                Log.newschool("fetchRemote messages, added \(message.content.prefix(20))")
                self?.insertMessage(message)
            }, onModified: { [weak self] (message) in
                Log.newschool("fetchRemote messages, added \(message.content.prefix(20))")
                self?.updateMessage(with: message.documentId, content: message.content)
            }, onRemoved: { [weak self] (message) in
                Log.newschool("fetchRemote messages, added \(message.content.prefix(20))")
                self?.deleteFromDB(with: message.documentId)
            }, onError: onError(_:))
    }
    
    func add(message content: String) {
        let messageData: [String: Any] = [
            Message.content: content,
            Message.created: Timestamp(date: Date()),
            Message.senderName: my.name,
            Message.senderId: my.uuid
        ]
        messagesManager.add(data: messageData) { (success) in
            Log.newschool("message added \(success)")
        }
    }
    
    private func insertMessage(_ message: Message) {
        let entity = MessageEntity(from: message, in: viewContext)
        channel.addToMessages(entity)
        viewContext.insert(entity)
        cache.saveContext()
    }
    
    private func updateMessage(with identifier: String, content: String) {
        let request: NSFetchRequest<MessageEntity> = MessageEntity.fetchRequest()
        request.predicate = NSPredicate(format: "documentId == %@", identifier)
        request.fetchLimit = 1
        do {
            let toUpdate = try viewContext.fetch(request)
            if !toUpdate.isEmpty {
                Log.newschool("deleting message \(toUpdate[0].content.prefix(20))")
                toUpdate[0].content = content
                cache.saveContext()
            }
        } catch { fatalError("cannot fetch message to update") }
    }
    
    private func deleteFromDB(with identifier: String) {
        let request: NSFetchRequest<MessageEntity> = MessageEntity.fetchRequest()
        request.predicate = NSPredicate(format: "documentId == %@", identifier)
        request.fetchLimit = 1
        do {
            let sacrifice = try viewContext.fetch(request)
            if !sacrifice.isEmpty {
                Log.newschool("deleting message \(sacrifice[0].content.prefix(20))")
                viewContext.delete(sacrifice[0])
                cache.performDelete()
            }
        } catch { fatalError("cannot fetch message for deletion") }
    }

    private func onError(_ message: String) {
        Log.newschool(message)
    }
}

//
// Created by Timun on 02.11.2020.
// Copyright (c) 2020 TimunInc. All rights reserved.
//

import Foundation
import CoreData
import Firebase

class SmartMessageManager: MessageManager {

    private let cache: LocalCache
    private let messagesManager: RemoteMessageManager
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
            onAdded: { [weak self] (messages) in
                guard let self = self else { return }
                Log.newschool("fetchRemote messages, added \(messages.count)")
                self.insert(messages, into: self.channel.identifier)
            }, onModified: { [weak self] (messages) in
                Log.newschool("fetchRemote messages, added \(messages.count)")
                self?.update(messages: messages)
            }, onRemoved: { [weak self] (messages) in
                Log.newschool("fetchRemote messages, added \(messages.count))")
                self?.deleteFromDB(messages)
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
    
    private func insert(_ messages: [Message], into channelId: String) {
//        let entity = MessageEntity(from: message, in: viewContext)
//        channel.addToMessages(entity)
//        viewContext.insert(entity)
//        cache.saveContext()
        cache.perforBackgroundSave { (context) in
            let entities = messages.map { MessageEntity(from: $0, in: context) }

            let request: NSFetchRequest<ChannelEntity> = ChannelEntity.fetchRequest()
            request.predicate = NSPredicate(format: "identifier == %@", channelId)
            request.fetchLimit = 1
            do {
                let channel = try context.fetch(request)
                if !channel.isEmpty {
                    channel[0].addToMessages(NSSet(array: entities))
                }
            } catch { Log.newschool("error fetching channel to add messages to")}
        }
    }
    
    private func update(messages: [Message]) {
        let identifiers = messages.map { $0.documentId }
        let request: NSFetchRequest<MessageEntity> = MessageEntity.fetchRequest()
        request.predicate = NSPredicate(format: "documentId in %@", identifiers)
        do {
            let toUpdate = try viewContext.fetch(request)
            toUpdate.forEach { (entity) in
                Log.newschool("updating message \(entity.content.prefix(20))")
                if let content = messages.first(where: { $0.documentId == entity.documentId })?.content {
                    entity.content = content
                }
            }
            cache.saveContext()
        } catch { fatalError("cannot fetch message to update") }
    }
    
    private func deleteFromDB(_ messages: [Message]) {
        let identifiers = messages.map { $0.documentId }
        let request: NSFetchRequest<MessageEntity> = MessageEntity.fetchRequest()
        request.predicate = NSPredicate(format: "documentId in %@", identifiers)
        do {
            let sacrifice = try viewContext.fetch(request)
            sacrifice.forEach { (entity) in
                Log.newschool("deleting message \(entity.content.prefix(20))")
                viewContext.delete(entity)
            }
            cache.performDelete()
        } catch { fatalError("cannot fetch message for deletion") }
    }

    private func onError(_ message: String) {
        Log.newschool(message)
    }
}

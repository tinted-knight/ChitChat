//
// Created by Timun on 02.11.2020.
// Copyright (c) 2020 TimunInc. All rights reserved.
//

import Foundation
import CoreData
import Firebase

protocol IMessageService {
    var channel: ChannelEntity { get }
    var frc: NSFetchedResultsController<MessageEntity> { get }
    
    func fetchRemote()
    func add(message content: String)
}

class MessageService: IMessageService {

    private let local: IStorage
    private let remote: IRemoteMessageStorage
    private let my: IFirestoreUser
    let channel: ChannelEntity

    init(for channel: ChannelEntity, me userData: IFirestoreUser, local: IStorage, remote: IRemoteMessageStorage) {
        self.local = local
        self.channel = channel
        self.my = userData
        self.remote = remote
    }

    lazy var frc: NSFetchedResultsController<MessageEntity> = {
        guard let viewContext = self.local.viewContext else { fatalError() }
        
        let sortMessages = NSSortDescriptor(key: "created", ascending: false)
        let predicate = NSPredicate(format: "channel.identifier == '\(channel.identifier)'")

        let frMessages = NSFetchRequest<MessageEntity>(entityName: "MessageEntity")
        frMessages.sortDescriptors = [sortMessages]
        frMessages.predicate = predicate

        return NSFetchedResultsController(fetchRequest: frMessages,
                managedObjectContext: viewContext,
                sectionNameKeyPath: nil,
                cacheName: nil)
    }()
    
    func fetchRemote() {
        remote.loadMessageList(
            onAdded: insert(_:),
            onModified: update(_:),
            onRemoved: deleteFromDB(_:),
            onError: onError(_:))
    }
    
    func add(message content: String) {
        let messageData: [String: Any] = [
            Message.content: content,
            Message.created: Timestamp(date: Date()),
            Message.senderName: my.name(),
            Message.senderId: my.uuid
        ]
        remote.add(data: messageData) { (success) in
            Log.newschool("message added \(success)")
        }
    }
    
    private func insert(_ messages: [Message]) {
        let identifier = channel.identifier
        local.saveInBackground { (context) in
            let request: NSFetchRequest<ChannelEntity> = ChannelEntity.fetchRequest()
            request.predicate = NSPredicate(format: "identifier == %@", identifier)
            request.fetchLimit = 1
            do {
                let into = try context.fetch(request)
                if !into.isEmpty {
                    let entities = messages.map { MessageEntity(from: $0, in: context)}
                    into[0].addToMessages(NSSet(array: Array(entities)))
                }
            } catch { fatalError("error inserting message, \(error.localizedDescription)") }
        }
    }
    
    private func update(_ messages: [Message]) {
        guard let viewContext = self.local.viewContext else { fatalError() }
        
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
            local.saveContext()
        } catch { fatalError("cannot fetch message to update") }
    }
    
    private func deleteFromDB(_ messages: [Message]) {
        guard let viewContext = self.local.viewContext else { fatalError() }
        
        let identifiers = messages.map { $0.documentId }
        let request: NSFetchRequest<MessageEntity> = MessageEntity.fetchRequest()
        request.predicate = NSPredicate(format: "documentId in %@", identifiers)
        do {
            let sacrifice = try viewContext.fetch(request)
            sacrifice.forEach { (entity) in
                Log.newschool("deleting message \(entity.content.prefix(20))")
                viewContext.delete(entity)
            }
            local.performDelete()
        } catch { fatalError("cannot fetch message for deletion") }
    }

    private func onError(_ message: String) {
        Log.newschool(message)
    }
}

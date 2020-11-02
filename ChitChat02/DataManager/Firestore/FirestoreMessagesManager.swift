//
//  MessagesManager.swift
//  ChitChat02
//
//  Created by Timun on 17.10.2020.
//  Copyright © 2020 TimunInc. All rights reserved.
//

import Foundation
import Firebase
import CoreData

class FirestoreMessageReader: FirestoreDataManager, MessagesReader {

    let channelId: String

    var channelMessages: CollectionReference {
        return db.collection(Channel.path).document(channelId).collection(Message.path)
    }

    init(for channelId: String) {
        self.channelId = channelId
    }

    func loadMessageList(onAdded: @escaping (Message) -> Void,
                         onModified: @escaping (Message) -> Void,
                         onRemoved: @escaping (Message) -> Void,
                         onError: @escaping (String) -> Void) {
        channelMessages.order(by: Message.created, descending: true).addSnapshotListener { (snapshot, error) in
            if let error = error {
                onError(error.localizedDescription)
                return
            }
            guard let snapshot = snapshot else { return }
            snapshot.documentChanges.forEach { (diff) in
                guard let message = Message(from: diff.document) else { return }
                switch diff.type {
                case .added:
                    onAdded(message)
                case .modified:
                    onModified(message)
                case .removed:
                    onRemoved(message)
                }
            }
        }
    }

    func loadMessageList(onData: @escaping ([Message]) -> Void, onError: @escaping (String) -> Void) {
        channelMessages.order(by: Message.created, descending: true).getDocuments { (snapshot, error) in
            if let error = error {
                onError(error.localizedDescription)
                return
            }

            let messages: [Message] = snapshot?.documents
                .compactMap({ (document) in Message(from: document)}) ?? []

            Log.fire("\(messages.count) valid messages of total \(snapshot?.documents.count ?? 0)")
            onData(messages)
        }
    }
}

class FirestoreMessageManager: FirestoreMessageReader, MessagesManager {
    
//    private let userData: UserData
    private let viewContext: NSManagedObjectContext
    private let channel: ChannelEntity

    init(for channel: ChannelEntity, with context: NSManagedObjectContext) {
        self.viewContext = context
        self.channel = channel
        super.init(for: channel.identifier)
    }
    
    lazy var frc: NSFetchedResultsController<MessageEntity> = {
        Log.oldschool("frcMess for \(channelId)")
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

    func add(data: [String: Any], completion: @escaping (Bool) -> Void) {
        channelMessages.addDocument(data: data) { (error) in
            if let error = error {
                Log.fire("adding message error: \(error.localizedDescription)")
                completion(false)
            } else {
                Log.fire("adding message success")
                completion(true)
            }
        }
    }
}

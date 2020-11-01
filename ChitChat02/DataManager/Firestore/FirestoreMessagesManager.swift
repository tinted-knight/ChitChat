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
    
    private let userData: UserData
    private let coreDataManager: CoreDataManager
    private let channel: ChannelEntity

    init(for channel: ChannelEntity, me user: UserData, with manager: CoreDataManager) {
        self.userData = user
        self.coreDataManager = manager
        self.channel = channel
        super.init(for: channel.identifier)
    }
    
    override func loadMessageList(onData: @escaping ([Message]) -> Void, onError: @escaping (String) -> Void) {
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
    
    lazy var frc: NSFetchedResultsController<MessageEntity> = {
        Log.oldschool("frcMess for \(channelId)")
        let sortMessages = NSSortDescriptor(key: "created", ascending: false)
        let predicate = NSPredicate(format: "channel.identifier like '\(channelId)'")

        let frMessages = NSFetchRequest<MessageEntity>(entityName: "MessageEntity")
        frMessages.sortDescriptors = [sortMessages]
        frMessages.predicate = predicate

        return NSFetchedResultsController(fetchRequest: frMessages,
                                          managedObjectContext: coreDataManager.coreDataStack.mainContext,
                                          sectionNameKeyPath: nil,
                                          cacheName: nil)
    }()

    func add(message: String, completion: @escaping () -> Void) {
        let newMessageData: [String: Any] = [
            Message.content: message,
            Message.created: Timestamp(date: Date()),
            Message.senderName: userData.name,
            Message.senderId: userData.uuid
        ]
        channelMessages.addDocument(data: newMessageData) { (error) in
            if let error = error {
                Log.fire("adding message error: \(error.localizedDescription)")
                return
            } else {
                Log.fire("adding message success")
                completion()
            }
        }
    }
}

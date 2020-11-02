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

class FirestoreMessageManager: FirestoreDataManager, RemoteMessageManager {
    
    private let viewContext: NSManagedObjectContext
    private let channel: ChannelEntity

    var channelMessages: CollectionReference {
        return db.collection(Channel.path).document(channel.identifier).collection(Message.path)
    }

    init(for channel: ChannelEntity, with context: NSManagedObjectContext) {
        self.viewContext = context
        self.channel = channel
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

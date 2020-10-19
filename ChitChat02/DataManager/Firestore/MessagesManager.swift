//
//  MessagesManager.swift
//  ChitChat02
//
//  Created by Timun on 17.10.2020.
//  Copyright © 2020 TimunInc. All rights reserved.
//

import Foundation
import Firebase

class FirestoreMessageManager: FirestoreDataManager, MessagesManager {
    
    private let channel: Channel
    private let userData: UserData

    init(for channel: Channel, me user: UserData) {
        self.channel = channel
        self.userData = user
    }
    
    func loadMessageList(onData: @escaping ([Message]) -> Void, onError: @escaping (String) -> Void) {
        Log.fire("\(#function) from \(channel.name)")
        channelMessages.order(by: Message.created, descending: true).addSnapshotListener { (snapshot, error) in
            if let error = error {
                onError(error.localizedDescription)
                return
            }

            let messages: [Message] = snapshot?.documents
                .compactMap({ (document) in
                    guard let content = document.data()[Message.content] as? String else { return nil }
                    guard let createdTimestamp = document.data()[Message.created] as? Timestamp else { return nil }
                    guard let senderId = document.data()[Message.senderId] as? String else { return nil }
                    guard let senderName = document.data()[Message.senderName] as? String  else { return nil }
                    
                    let created: Date = createdTimestamp.dateValue()

                    return Message(
                        content: content,
                        created: created,
                        senderId: senderId,
                        senderName: senderName)
                }) ?? []

            Log.fire("\(messages.count) valid messages of total \(snapshot?.documents.count ?? 0)")
            onData(messages)
        }
    }

    func add(message: String) {
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
            }
        }
    }
    
    private var channelMessages: CollectionReference {
        return db.collection(Channel.path).document(channel.indentifier).collection(Message.path)
    }
}

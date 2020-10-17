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
        applog("\(#function) from \(channel.name)")
        channelMessages.addSnapshotListener { (snapshot, error) in
            if let error = error {
                onError(error.localizedDescription)
                return
            }
            
            let messages: [Message] = snapshot?.documents
                .map({ (document) in
                    let content = document.data()[Message.content] as? String ?? "no content"
                    let createdTimestamp = document.data()[Message.created] as? Timestamp
                    let created: Date = createdTimestamp?.dateValue() ?? Date()
                    let senderId = document.data()[Message.senderId] as? String ?? "no senderId"
                    let senderName = document.data()[Message.senderName] as? String ?? "no senderName"
                    
                    return Message(
                        content: content,
                        created: created,
                        senderId: senderId,
                        senderName: senderName)
                }) ?? []
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

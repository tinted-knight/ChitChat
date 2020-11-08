//
//  MessagesManager.swift
//  ChitChat02
//
//  Created by Timun on 17.10.2020.
//  Copyright © 2020 TimunInc. All rights reserved.
//

import Foundation
import Firebase

class FirestoreMessageReader: FirestoreDataManager, MessagesReader {

    private let channel: Channel

    var channelMessages: CollectionReference {
        return db.collection(Channel.path).document(channel.indentifier).collection(Message.path)
    }

    init(for channel: Channel) {
        self.channel = channel
    }

    func loadMessageList(onData: @escaping ([Message]) -> Void, onError: @escaping (String) -> Void) {
        Log.fire("\(#function) from \(channel.name)")
        channelMessages.order(by: Message.created, descending: true).addSnapshotListener { (snapshot, error) in
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

    init(for channel: Channel, me user: UserData) {
        self.userData = user
        super.init(for: channel)
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
}

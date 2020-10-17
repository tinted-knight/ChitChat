//
//  FirestoreDataManager.swift
//  ChitChat02
//
//  Created by Timun on 17.10.2020.
//  Copyright © 2020 TimunInc. All rights reserved.
//

import Foundation
import Firebase

protocol ChannelsManager {
    func loadChannelList(onData: @escaping ([Channel]) -> Void, onError: @escaping (String) -> Void)
    func addChannel(name: String)
}

protocol MessagesManager {
    func loadMessageList(onData: @escaping ([Message]) -> Void, onError: @escaping (String) -> Void)
    func add(message: String)
}

struct Channel {
    let indentifier: String
    let name: String
    let lastMessage: String?
    let lastActivity: Date?
}

struct Message {
    let content: String
    let created: Date
    let senderId: String
    let senderName: String
}

struct UserData {
    let uuid: String
    let name = "Timur"

    static let keyUUID = "key-uuid"
}

class FirestoreDataManager {
    internal lazy var db = Firestore.firestore()
    static var uuid: String?
}
// MARK: ChannelsManager
class FirestoreChannelManager: FirestoreDataManager, ChannelsManager {
    private var channels: CollectionReference {
        return db.collection("channels")
    }

    func loadChannelList(onData: @escaping ([Channel]) -> Void, onError: @escaping (String) -> Void) {
        channels.addSnapshotListener { (snapshot, error) in
            if let error = error {
                onError(error.localizedDescription)
                return
            }
            
            let channels: [Channel]  = snapshot?.documents
                .filter({ document in
                    guard let name = document.data()["name"] as? String, !name.isEmpty else { return false }
                    return true
                })
                .map({ document in
                    let id: String = document.documentID
                    let name: String = document.data()["name"] as? String ?? "noname"
                    let lastMessage: String? = document.data()["lastMessage"] as? String
                    let timestamp: Timestamp? = document.data()["lastActivity"] as? Timestamp
                    let lastActivity: Date? = timestamp?.dateValue()
                    
                    return Channel(
                        indentifier: id,
                        name: name,
                        lastMessage: lastMessage,
                        lastActivity: lastActivity)
                }) ?? []

            onData(channels)
        }
    }
    
    func addChannel(name: String) {
        let newChannelData: [String: Any] = [
            "name": name,
            "lastMessage": "Опасно!11",
            "lastActivity": Timestamp(date: Date())
        ]
        channels.addDocument(data: newChannelData) { (error) in
            if let error = error {
                Log.fire("creating channel error: \(error.localizedDescription)")
                return
            } else {
                Log.fire("creating channel success")
            }
        }
    }
}
// MARK: MessagesManager
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
                    let content = document.data()["content"] as? String ?? "no content"
                    let createdTimestamp = document.data()["created"] as? Timestamp
                    let created: Date = createdTimestamp?.dateValue() ?? Date()
                    let senderId = document.data()["senderId"] as? String ?? "no senderId"
                    let senderName = document.data()["senderName"] as? String ?? "no senderName"
                    
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
            "content": message,
            "created": Timestamp(date: Date()),
            "senderName": userData.name,
            "senderId": userData.uuid
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
        return db.collection("channels").document(channel.indentifier).collection("messages")
    }
}

//
//  models.swift
//  ChitChat02
//
//  Created by Timun on 17.10.2020.
//  Copyright © 2020 TimunInc. All rights reserved.
//

import Foundation
import Firebase

enum ChannelError: Error {
    case name, timestamp
}

// MARK: Channel
struct Channel: Hashable {
    let indentifier: String
    let name: String
    let lastMessage: String?
    let lastActivity: Date?
    
    init?(from document: QueryDocumentSnapshot) {
        guard let name = document.data()[Channel.name] as? String else { return nil }
        guard let timestamp = document.data()[Channel.lastActivity] as? Timestamp else { return nil }

        let id: String = document.documentID
        let lastActivity = timestamp.dateValue()
        let lastMessage = document.data()[Channel.lastMessage] as? String
        
        self.indentifier = id
        self.name = name
        self.lastMessage = lastMessage
        self.lastActivity = lastActivity
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.indentifier)
    }
}

extension Channel: Codable {
    static let path = "channels"
    
    static let name = "name"
    static let lastMessage = "lastMessage"
    static let lastActivity = "lastActivity"
}

// MARK: Message
struct Message {
    let content: String
    let created: Date
    let senderId: String
    let senderName: String
    
    init?(from document: QueryDocumentSnapshot) {
        guard let content = document.data()[Message.content] as? String else { return nil }
        guard let createdTimestamp = document.data()[Message.created] as? Timestamp else { return nil }
        guard let senderId = document.data()[Message.senderId] as? String else { return nil }
        guard let senderName = document.data()[Message.senderName] as? String  else { return nil }
        
        let created: Date = createdTimestamp.dateValue()
        
        self.content = content
        self.created = created
        self.senderId = senderId
        self.senderName = senderName
    }
}

extension Message {
    static let path = "messages"
    
    static let content = "content"
    static let created = "created"
    static let senderId = "senderId"
    static let senderName = "senderName"
}

// MARK: UserData
struct UserData {
    let uuid: String
    let name = "Timur"

    static let keyUUID = "key-uuid"
}

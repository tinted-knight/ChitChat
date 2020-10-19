//
//  models.swift
//  ChitChat02
//
//  Created by Timun on 17.10.2020.
//  Copyright © 2020 TimunInc. All rights reserved.
//

import Foundation

// MARK: Channel
struct Channel {
    let indentifier: String
    let name: String
    let lastMessage: String?
    let lastActivity: Date?
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

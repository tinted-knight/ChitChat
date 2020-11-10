//
//  ConversationCellModel.swift
//  ChitChat02
//
//  Created by Timun on 28.09.2020.
//  Copyright © 2020 TimunInc. All rights reserved.
//

import Foundation

protocol IChannelCellModel {
    var name: String { get }
    var lastMessage: String? { get }
    var lastActivity: Date? { get }
    var hasUnreadMessages: Bool { get }
    var emptyMessage: String { get }
}

class ChannelCellModel: IChannelCellModel {
    static let noMessages = "No messages yet"
    
    let name: String
    let lastMessage: String?
    let lastActivity: Date?
    let hasUnreadMessages: Bool
    lazy var emptyMessage: String = ChannelCellModel.noMessages
    
    init(from channel: ChannelEntity) {
        self.name = channel.name
        self.lastMessage = channel.lastMessage
        self.lastActivity = channel.lastActivity
        self.hasUnreadMessages = channel.lastMessage != nil
    }
}

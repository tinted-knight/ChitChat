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
}

class ChannelCellModel: IChannelCellModel {
    let name: String
    let lastMessage: String?
    let lastActivity: Date?
    let hasUnreadMessages: Bool
    
    init(from channel: ChannelEntity) {
        self.name = channel.name
        self.lastMessage = channel.lastMessage
        self.lastActivity = channel.lastActivity
        self.hasUnreadMessages = channel.lastMessage != nil
    }
}

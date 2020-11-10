//
//  MessageCellModel.swift
//  ChitChat02
//
//  Created by Timun on 28.09.2020.
//  Copyright © 2020 TimunInc. All rights reserved.
//

import Foundation

protocol IMessageCellModel {
    var text: String { get }
    var date: Date { get }
    var sender: String { get }
    var direction: MessageDirection { get }
}

enum MessageDirection {
    case income
    case outcome
}

class MessageCellModel: IMessageCellModel {
    let text: String
    let date: Date
    let sender: String
    let direction: MessageDirection
    
    init(from message: MessageEntity, me myId: String) {
        self.text = message.content
        self.date = message.created
        self.sender = message.senderName
        if message.senderId == myId {
            self.direction = .outcome
        } else {
            self.direction = .income
        }
    }
}

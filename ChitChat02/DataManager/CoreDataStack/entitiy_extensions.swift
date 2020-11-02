//
//  coredata_extensions.swift
//  ChitChat02
//
//  Created by Timun on 23.10.2020.
//  Copyright © 2020 TimunInc. All rights reserved.
//

import Foundation
import CoreData

extension MessageEntity {
    convenience init(from model: Message, in context: NSManagedObjectContext) {
        self.init(context: context)
        self.documentId = model.documentId
        self.content = model.content
        self.created = model.created
        self.senderId = model.senderId
        self.senderName = model.senderName
    }
}

extension ChannelEntity {
    convenience init(from model: Channel, in context: NSManagedObjectContext) {
        self.init(context: context)
        self.identifier = model.identifier
        self.name = model.name
        self.lastMessage = model.lastMessage
        self.lastActivity = model.lastActivity
    }
}

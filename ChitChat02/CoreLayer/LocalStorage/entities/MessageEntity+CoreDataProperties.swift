//
//  MessageEntity+CoreDataProperties.swift
//  ChitChat02
//
//  Created by Timun on 10.11.2020.
//  Copyright © 2020 TimunInc. All rights reserved.
//
//

import Foundation
import CoreData

extension MessageEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MessageEntity> {
        return NSFetchRequest<MessageEntity>(entityName: "MessageEntity")
    }

    @NSManaged public var content: String
    @NSManaged public var created: Date
    @NSManaged public var documentId: String
    @NSManaged public var senderId: String
    @NSManaged public var senderName: String
    @NSManaged public var channel: ChannelEntity?

}

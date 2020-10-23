//
//  ChannelEntity+CoreDataProperties.swift
//  ChitChat02
//
//  Created by Timun on 23.10.2020.
//  Copyright © 2020 TimunInc. All rights reserved.
//
//

import Foundation
import CoreData

extension ChannelEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ChannelEntity> {
        return NSFetchRequest<ChannelEntity>(entityName: "ChannelEntity")
    }

    @NSManaged public var identifier: String
    @NSManaged public var lastActivity: Date?
    @NSManaged public var lastMessage: String?
    @NSManaged public var name: String
    @NSManaged public var messages: NSSet?

}

// MARK: Generated accessors for messages
extension ChannelEntity {

    @objc(addMessagesObject:)
    @NSManaged public func addToMessages(_ value: MessageEntity)

    @objc(removeMessagesObject:)
    @NSManaged public func removeFromMessages(_ value: MessageEntity)

    @objc(addMessages:)
    @NSManaged public func addToMessages(_ values: NSSet)

    @objc(removeMessages:)
    @NSManaged public func removeFromMessages(_ values: NSSet)

}

//
//  TestRequest.swift
//  ChitChat02
//
//  Created by Timun on 23.10.2020.
//  Copyright © 2020 TimunInc. All rights reserved.
//

import Foundation

struct TestRequest {
    let coreDataStack: CoreDataStack
    
    init(_ coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
    }
    
    func makeRequest() {
//        coreDataStack.performSave { (context) in
//            let channel1 = ChannelEntity(indentifier: "id01",
//                                         name: "name01",
//                                         lastMessage: nil,
//                                         lastActivity: nil,
//                                         in: context)
//
//            let message1 = MessageEntity(content: "mess1",
//                                         created: Date(),
//                                         senderId: "senderId01",
//                                         senderName: "Vasya",
//                                         in: context)
//            let message2 = MessageEntity(content: "mess2",
//                                         created: Date(),
//                                         senderId: "senderId02",
//                                         senderName: "NoPetya",
//                                         in: context)
//
//            [message1, message2].forEach { channel1.addToMessages($0) }
//        }
    }
}

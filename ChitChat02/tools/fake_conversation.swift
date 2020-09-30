//
//  fake_conversation.swift
//  ChitChat02
//
//  Created by Timun on 28.09.2020.
//  Copyright © 2020 TimunInc. All rights reserved.
//

import Foundation

private func randomDirection() -> MessageDirection {
    if Bool.random() {
        return .income
    } else {
        return .outcome
    }
}

let fakeMessages = [
    MessageCellModel(text: "message text newest", date: fakeDate(), direction: randomDirection()),
    MessageCellModel(text: "message text 1", date: fakeDate(), direction: randomDirection()),
    MessageCellModel(text: "message text 2", date: fakeDate(), direction: randomDirection()),
    MessageCellModel(text: "message text 3", date: fakeDate(), direction: randomDirection()),
    MessageCellModel(text: "message text\nmessage text\nmessage text\n", date: fakeDate(), direction: randomDirection()),
    MessageCellModel(text: "message text\nmessage text\nmessage text\n", date: fakeDate(), direction: randomDirection()),
    MessageCellModel(text: "message text\nmessage text\nmessage text\n", date: fakeDate(), direction: randomDirection()),
    MessageCellModel(text: "message text\nmessage text\nmessage text\n", date: fakeDate(), direction: randomDirection()),
    MessageCellModel(text: "message text\nmessage text\nmessage text\n", date: fakeDate(), direction: randomDirection()),
    MessageCellModel(text: "message text\nmessage text\nmessage text\n", date: fakeDate(), direction: randomDirection()),
    MessageCellModel(text: "message text\nmessage text\nmessage text\n", date: fakeDate(), direction: randomDirection()),
    MessageCellModel(text: "message text\nmessage text\nmessage text\n", date: fakeDate(), direction: randomDirection()),
    MessageCellModel(text: "message text\nmessage text\nmessage text\n", date: fakeDate(), direction: randomDirection()),
    MessageCellModel(text: "message text\nmessage text\nmessage text\n", date: fakeDate(), direction: randomDirection()),
    MessageCellModel(text: "message text oldest\nmessage text\nmessage text\n", date: fakeDate(), direction: randomDirection()),
]

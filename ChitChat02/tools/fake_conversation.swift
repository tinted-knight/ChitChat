//
//  fake_conversation.swift
//  ChitChat02
//
//  Created by Timun on 28.09.2020.
//  Copyright © 2020 TimunInc. All rights reserved.
//

import Foundation

let fakeMessages = [
    MessageCellModel(text: "message text 0", date: fakeDate(), direction: .income),
    MessageCellModel(text: "message text 1", date: fakeDate(), direction: .income),
    MessageCellModel(text: "message text 2", date: fakeDate(), direction: .outcome),
    MessageCellModel(text: "message text 3", date: fakeDate(), direction: .income),
    MessageCellModel(text: "message text 4", date: fakeDate(), direction: .outcome),
]

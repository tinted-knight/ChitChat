//
//  MessageCellModel.swift
//  ChitChat02
//
//  Created by Timun on 28.09.2020.
//  Copyright © 2020 TimunInc. All rights reserved.
//

import Foundation

enum MessageDirection {
    case income
    case outcome
}

struct MessageCellModel {
    let text: String
    let date: Date
    let direction: MessageDirection
}

//
//  GeneralMessageCell.swift
//  ChitChat02
//
//  Created by Timun on 29.09.2020.
//  Copyright © 2020 TimunInc. All rights reserved.
//

import Foundation

class BaseMessageCell  {

    private let formatter = DateFormatter()
    private let calendar = Calendar.current

    private func formatDateTime(with date: Date) -> String {
        if calendar.startOfDay(for: date) != calendar.startOfDay(for: Date()) {
            formatter.dateFormat = "dd MMM"
        } else {
            formatter.dateFormat = "HH:mm"
        }
        return formatter.string(from: date)
    }
}

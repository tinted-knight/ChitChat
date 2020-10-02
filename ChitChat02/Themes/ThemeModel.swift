//
//  ThemeModel.swift
//  ChitChat02
//
//  Created by Timun on 02.10.2020.
//  Copyright © 2020 TimunInc. All rights reserved.
//

import Foundation
import UIKit

enum Brightness {
    case light
    case dark
}

struct ThemeModel {
    let name: String
    let backgroundColor: UIColor
    let textColor: UIColor
    let incomeBgColor: UIColor
    let outcomeBgColor: UIColor
    let incomeTextColor: UIColor
    let outcomeTextColor: UIColor
    let onlineBgColor: UIColor
    let historyBgColor: UIColor
}

let fakeThemeData = [
    ThemeModel(
        name: "Classic",
        backgroundColor: .white,
        textColor: .black,
        incomeBgColor: .green,
        outcomeBgColor: .lightGray,
        incomeTextColor: .black,
        outcomeTextColor: .black,
        onlineBgColor: UIColor.yellow.withAlphaComponent(0.2),
        historyBgColor: .white
    ),
    ThemeModel(
        name: "Yellow",
        backgroundColor: .yellow,
        textColor: .black,
        incomeBgColor: .orange,
        outcomeBgColor: .red,
        incomeTextColor: .white,
        outcomeTextColor: .white,
        onlineBgColor: UIColor.yellow.withAlphaComponent(0.2),
        historyBgColor: .yellow
    ),
    ThemeModel(
        name: "Dark",
        backgroundColor: .darkGray,
        textColor: .white,
        incomeBgColor: .gray,
        outcomeBgColor: .black,
        incomeTextColor: .white,
        outcomeTextColor: .lightGray,
        onlineBgColor: UIColor(displayP3Red: 0.95, green: 0.76, blue: 0.20, alpha: 1),
        historyBgColor: .darkGray
    ),
]

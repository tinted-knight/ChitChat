//
//  ThemeModel.swift
//  ChitChat02
//
//  Created by Timun on 02.10.2020.
//  Copyright © 2020 TimunInc. All rights reserved.
//

import Foundation
import UIKit

enum Theme: Int {
    case classic = 0
    case yellow = 1
    case black = 2
}

enum Brightness {
    case light
    case dark
}

struct ThemeModel {
    let name: String
    let brightness: Brightness
    let backgroundColor: UIColor
    let textColor: UIColor
    let incomeBgColor: UIColor
    let outcomeBgColor: UIColor
    let incomeTextColor: UIColor
    let outcomeTextColor: UIColor
    let onlineBgColor: UIColor
    let historyBgColor: UIColor
    let tintColor: UIColor
    let buttonBgColor: UIColor
}

let fakeThemeData = [
    ThemeModel(
        name: "Classic",
        brightness: .light,
        backgroundColor: .white,
        textColor: .black,
        incomeBgColor: .green,
        outcomeBgColor: .lightGray,
        incomeTextColor: .black,
        outcomeTextColor: .black,
        onlineBgColor: UIColor.yellow.withAlphaComponent(0.2),
        historyBgColor: .white,
        tintColor: .systemBlue,
        buttonBgColor: .lightGray
    ),
    ThemeModel(
        name: "Yellow",
        brightness: .light,
        backgroundColor: .yellow,
        textColor: UIColor(red: 0, green: 0.0627, blue: 0.6392, alpha: 1.0),
        incomeBgColor: .orange,
        outcomeBgColor: .red,
        incomeTextColor: .white,
        outcomeTextColor: .white,
        onlineBgColor: UIColor.yellow.withAlphaComponent(0.2),
        historyBgColor: .yellow,
        tintColor: .systemRed,
        buttonBgColor: .white
    ),
    ThemeModel(
        name: "Dark",
        brightness: .dark,
        backgroundColor: .black,
        textColor: .white,
        incomeBgColor: UIColor(displayP3Red: 0.2, green: 0.2, blue: 0.2, alpha: 1),
        outcomeBgColor: UIColor(displayP3Red: 0.1, green: 0.1, blue: 0.1, alpha: 1),
        incomeTextColor: .white,
        outcomeTextColor: .white,
        onlineBgColor: .darkGray,
        historyBgColor: .black,
        tintColor: .systemBlue,
        buttonBgColor: UIColor(displayP3Red: 0.1, green: 0.1, blue: 0.1, alpha: 1)
    ),
]

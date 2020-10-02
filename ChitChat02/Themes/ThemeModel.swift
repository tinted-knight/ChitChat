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
    let incomeBgColor: UIColor
    let outcomeBgColor: UIColor
    let brightness: Brightness
}

let fakeThemeData = [
    ThemeModel(
        name: "Classic",
        backgroundColor: .white,
        incomeBgColor: .green,
        outcomeBgColor: .lightGray,
        brightness: .light
    ),
    ThemeModel(
        name: "Yellow",
        backgroundColor: .yellow,
        incomeBgColor: .orange,
        outcomeBgColor: .red,
        brightness: .light
    ),
    ThemeModel(
        name: "Dark",
        backgroundColor: .darkGray,
        incomeBgColor: .gray,
        outcomeBgColor: .white,
        brightness: .dark
    ),
]

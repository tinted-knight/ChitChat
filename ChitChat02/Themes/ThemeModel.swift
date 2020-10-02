//
//  ThemeModel.swift
//  ChitChat02
//
//  Created by Timun on 02.10.2020.
//  Copyright © 2020 TimunInc. All rights reserved.
//

import Foundation
import UIKit

struct ThemeModel {
    let name: String
    let backgroundColor: UIColor
    let incomeBgColor: UIColor
    let outcomeBgColor: UIColor
}

let fakeThemeData = [
    ThemeModel(name: "Red", backgroundColor: .red, incomeBgColor: .blue, outcomeBgColor: .red),
    ThemeModel(name: "Yellow", backgroundColor: .yellow, incomeBgColor: .orange, outcomeBgColor: .green),
    ThemeModel(name: "Green", backgroundColor: .green, incomeBgColor: .blue, outcomeBgColor: .green)
]

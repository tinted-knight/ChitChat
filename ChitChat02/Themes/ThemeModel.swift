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
    ThemeModel(name: "LightBlueRed", backgroundColor: .white, incomeBgColor: .blue, outcomeBgColor: .red),
    ThemeModel(name: "LightOrangeGreen", backgroundColor: .white, incomeBgColor: .orange, outcomeBgColor: .green),
    ThemeModel(name: "DarkBlueGreen", backgroundColor: .black, incomeBgColor: .blue, outcomeBgColor: .green)
]

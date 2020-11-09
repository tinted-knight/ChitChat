//
//  ThemeModel.swift
//  ChitChat02
//
//  Created by Timun on 02.10.2020.
//  Copyright © 2020 TimunInc. All rights reserved.
//

import Foundation
import UIKit

enum AppTheme: Int {
    case classic = 0
    case yellow = 1
    case black = 2
}

enum Brightness: Codable {
    case light
    case dark
    
    enum Key: CodingKey { case rawValue }
    
    enum CodingError: Error { case unknownValue }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)
        let rawValue = try container.decode(Int.self, forKey: .rawValue)
        switch rawValue {
        case 0:
            self = .light
        case 1:
            self = .dark
        default:
            throw CodingError.unknownValue
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Key.self)
        switch self {
        case .light:
            try container.encode(0, forKey: .rawValue)
        case .dark:
            try container.encode(0, forKey: .rawValue)
        }
    }
}

struct Color: Codable {
    var red: CGFloat = 0.0, green: CGFloat = 0.0, blue: CGFloat = 0.0, alpha: CGFloat = 0.0

    var uiColor: UIColor {
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }

    init(_ uiColor: UIColor) {
        uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
    }
}

struct ThemeModel: Codable {
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
    
    private enum CodingKeys: String, CodingKey {
        case name, brightness, backgroundColor, textColor, incomeBgColor,
        outcomeBgColor, incomeTextColor, outcomeTextColor,
        onlineBgColor, historyBgColor, tintColor, buttonBgColor
    }

    init(name: String, brightness: Brightness, backgroundColor: UIColor, textColor: UIColor,
         incomeBgColor: UIColor, outcomeBgColor: UIColor, incomeTextColor: UIColor,
         outcomeTextColor: UIColor, onlineBgColor: UIColor, historyBgColor: UIColor,
         tintColor: UIColor, buttonBgColor: UIColor) {
        self.name = name
        self.brightness = brightness
        self.backgroundColor = backgroundColor
        self.textColor = textColor
        self.incomeBgColor = incomeBgColor
        self.outcomeBgColor = outcomeBgColor
        self.incomeTextColor = incomeTextColor
        self.outcomeTextColor = outcomeTextColor
        self.onlineBgColor = onlineBgColor
        self.historyBgColor = historyBgColor
        self.tintColor = tintColor
        self.buttonBgColor = buttonBgColor
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        brightness = try container.decode(Brightness.self, forKey: .brightness)
        backgroundColor = try container.decode(Color.self, forKey: .backgroundColor).uiColor
        textColor = try container.decode(Color.self, forKey: .textColor).uiColor
        incomeBgColor = try container.decode(Color.self, forKey: .incomeBgColor).uiColor
        outcomeBgColor = try container.decode(Color.self, forKey: .outcomeBgColor).uiColor
        incomeTextColor = try container.decode(Color.self, forKey: .incomeTextColor).uiColor
        outcomeTextColor = try container.decode(Color.self, forKey: .outcomeTextColor).uiColor
        onlineBgColor = try container.decode(Color.self, forKey: .onlineBgColor).uiColor
        historyBgColor = try container.decode(Color.self, forKey: .historyBgColor).uiColor
        tintColor = try container.decode(Color.self, forKey: .tintColor).uiColor
        buttonBgColor = try container.decode(Color.self, forKey: .buttonBgColor).uiColor
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(brightness, forKey: .brightness)
        try container.encode(Color(backgroundColor), forKey: .backgroundColor)
        try container.encode(Color(textColor), forKey: .textColor)
        try container.encode(Color(incomeBgColor), forKey: .incomeBgColor)
        try container.encode(Color(outcomeBgColor), forKey: .outcomeBgColor)
        try container.encode(Color(incomeTextColor), forKey: .incomeTextColor)
        try container.encode(Color(outcomeTextColor), forKey: .outcomeTextColor)
        try container.encode(Color(onlineBgColor), forKey: .onlineBgColor)
        try container.encode(Color(historyBgColor), forKey: .historyBgColor)
        try container.encode(Color(tintColor), forKey: .tintColor)
        try container.encode(Color(buttonBgColor), forKey: .buttonBgColor)
    }
}

let fakeThemeData = [
    ThemeModel(
        name: "Classic",
        brightness: .light,
        backgroundColor: .white,
        textColor: .black,
        incomeBgColor: UIColor.green.withAlphaComponent(0.2),
        outcomeBgColor: UIColor.lightGray.withAlphaComponent(0.2),
        incomeTextColor: .black,
        outcomeTextColor: .black,
        onlineBgColor: UIColor.yellow.withAlphaComponent(0.2),
        historyBgColor: .white,
        tintColor: .systemBlue,
        buttonBgColor: UIColor(displayP3Red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
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
    )
]

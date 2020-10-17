//
//  fake_random_date.swift
//  ChitChat02
//
//  Created by Timun on 29.09.2020.
//  Copyright © 2020 TimunInc. All rights reserved.
//

import Foundation

func fakeDate() -> Date {
    return Date(timeIntervalSinceNow: -Double.random(in: 1...60) * Double.random(in: 30...60) * Double.random(in: 1...3) * 26)
}

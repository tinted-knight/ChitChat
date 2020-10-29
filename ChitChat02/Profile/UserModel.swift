//
//  UserModel.swift
//  ChitChat02
//
//  Created by Timun on 09.10.2020.
//  Copyright © 2020 TimunInc. All rights reserved.
//

import Foundation

struct UserModel {
    let name: String
    let description: String
    var avatar: URL?
}

let newUser = UserModel(name: "", description: "")

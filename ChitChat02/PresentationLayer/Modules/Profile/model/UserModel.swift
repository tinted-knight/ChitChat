//
//  UserModel.swift
//  ChitChat02
//
//  Created by Timun on 09.10.2020.
//  Copyright © 2020 TimunInc. All rights reserved.
//

import Foundation

protocol IUserModel {
    var name: String { get }
    var description: String { get }
    var avatar: URL? { get set }
}

struct UserModel: IUserModel {
    let name: String
    let description: String
    var avatar: URL?
}

let newUser = UserModel(name: "", description: "")

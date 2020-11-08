//
//  UserModel.swift
//  ChitChat02
//
//  Created by Timun on 08.11.2020.
//  Copyright © 2020 TimunInc. All rights reserved.
//

import Foundation

protocol IUserDataModel {
    var uuid: String { get }
    
    var name: String { get }
}

class UserDataModel: IUserDataModel {
    private let userDataService: IUserDataService
    
    lazy var uuid: String = self.userDataService.uuid
    
    lazy var name: String = "Timur"
    
    init(userDataService: IUserDataService) {
        self.userDataService = userDataService
    }
}

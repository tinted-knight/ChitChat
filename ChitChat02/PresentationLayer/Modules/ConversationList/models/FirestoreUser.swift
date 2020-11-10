//
//  UserModel.swift
//  ChitChat02
//
//  Created by Timun on 08.11.2020.
//  Copyright © 2020 TimunInc. All rights reserved.
//

import Foundation

protocol IFirestoreUser {
    var uuid: String { get }
    
    func name() -> String
    
    func update(name: String)
}

class FirestoreUser: IFirestoreUser {
    private let firestoreUserService: IFirestoreUserService
    
    lazy var uuid: String = self.firestoreUserService.uuid
    
    init(userDataService: IFirestoreUserService) {
        self.firestoreUserService = userDataService
    }
    
    func name() -> String {
        return self.firestoreUserService.name
    }

    func update(name: String) {
        firestoreUserService.update(name: name)
    }
}

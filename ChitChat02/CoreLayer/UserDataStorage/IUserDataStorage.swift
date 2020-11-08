//
// Created by Timun on 08.11.2020.
// Copyright (c) 2020 TimunInc. All rights reserved.
//

import Foundation

protocol IUserDataStorage {
    
    func load(key: String) -> String?
    
    func save(uuid: String)
}

class UserDataStorage: IUserDataStorage {
    private let prefs = UserDefaults.standard
    
    func load(key: String) -> String? {
        return prefs.string(forKey: key)
    }
    
    func save(uuid: String) {
        prefs.set(uuid, forKey: UserData.keyUUID)
    }
}

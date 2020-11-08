//
// Created by Timun on 08.11.2020.
// Copyright (c) 2020 TimunInc. All rights reserved.
//

import Foundation

protocol IKeyValueStorage {
    
    func load(key: String) -> String?
    
    func integer(key: String) -> Int
    
    func save(value: String)
}

class KeyValueStorage: IKeyValueStorage {
    private let prefs = UserDefaults.standard
    
    func load(key: String) -> String? {
        return prefs.string(forKey: key)
    }
    
    func integer(key: String) -> Int {
        return prefs.integer(forKey: key)
    }
    
    func save(value: String) {
        prefs.set(value, forKey: UserData.keyUUID)
    }
}

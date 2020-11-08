//
//  UserDataService.swift
//  ChitChat02
//
//  Created by Timun on 08.11.2020.
//  Copyright © 2020 TimunInc. All rights reserved.
//

import Foundation

protocol IUserDataService {
    var uuid: String { get }
}

class UserDataService: IUserDataService {
    
    private let storage: IKeyValueStorage
    
    let uuid: String
    
    init(storage: IKeyValueStorage) {
        self.storage = storage
        
        if let uuid = storage.load(key: UserData.keyUUID) {
            Log.prefs("existing uuid = \(uuid)")
            self.uuid = uuid
        } else {
            let uuid = UUID().uuidString
            Log.prefs("new uuid = \(uuid)")
            storage.save(value: uuid)
            self.uuid = uuid
        }
    }
}

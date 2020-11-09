//
//  UserDataService.swift
//  ChitChat02
//
//  Created by Timun on 08.11.2020.
//  Copyright © 2020 TimunInc. All rights reserved.
//

import Foundation

protocol IFirestoreUserService {
    var uuid: String { get }
    
    var name: String { get }
    
    func update(name: String)
}

class FirestoreService: IFirestoreUserService {
    
    private let storage: IKeyValueStorage
    
    let uuid: String
    
    var name: String
    
    init(storage: IKeyValueStorage) {
        self.storage = storage
        
        if let uuid = storage.load(key: UserData.keyUUID) {
            Log.prefs("existing uuid = \(uuid)")
            self.uuid = uuid
        } else {
            let uuid = UUID().uuidString
            Log.prefs("new uuid = \(uuid)")
            storage.save(value: uuid, forKey: UserData.keyUUID)
            self.uuid = uuid
        }

        if let name = storage.load(key: UserData.keyName) {
            Log.prefs("existing name = \(name)")
            self.name = name
        } else {
            Log.prefs("no name in prefs")
            let myName = "Timur Tharkahov"
            storage.save(value: myName, forKey: UserData.keyName)
            self.name = myName
        }
    }
    
    func update(name: String) {
        Log.arch("prefs update name \(name)")
        storage.save(value: name, forKey: UserData.keyName)
        self.name = name
    }
}

//
//  SaveCompletionOperation.swift
//  ChitChat02
//
//  Created by Timun on 12.10.2020.
//  Copyright © 2020 TimunInc. All rights reserved.
//

import Foundation

enum SaveUserResult {
    case success
    case error(_ value: String)
}

class SaveCompletionOperation: Operation {
    private var saveName: ResultOperation
    private var saveDesc: ResultOperation
    private var saveAvatar: ResultOperation
    private var error: String = ""
    private(set) var result: SaveUserResult?

    init(nameOp: ResultOperation, descOp: ResultOperation, avatarOp: ResultOperation) {
        saveName = nameOp
        saveDesc = descOp
        saveAvatar = avatarOp
        
        super.init()
    }
    
    override func main() {
        guard let nameRes = saveName.result else {
            result = .error("save name error")
            return
        }
        
        guard let descRes = saveDesc.result else {
            result = .error("save desc error")
            return
        }
        
        guard let avatarRes = saveAvatar.result else {
            result = .error("save avatar error")
            return
        }
        
        switch nameRes {
            case .error(let value):
                result = .error(value)
                return
            case .success:
                result = .success
        }
        
        switch descRes {
            case .error(let value):
                result = .error(value)
                return
            case .success:
                result = .success
        }
        
        switch avatarRes {
            case .error(let value):
                result = .error(value)
            case .success:
                result = .success
        }
    }
}

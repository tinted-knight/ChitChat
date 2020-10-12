//
//  SaveOperation.swift
//  ChitChat02
//
//  Created by Timun on 10.10.2020.
//  Copyright © 2020 TimunInc. All rights reserved.
//

import Foundation

internal enum SaveOperationResult {
    case success
    case error(_ value: String)
}

class ResultOperation: Operation{
    var result: SaveOperationResult?
    override func main() {
        result = .success
    }
}

class SaveStringOperation: ResultOperation {
    var to: URL?
    var value: String?
    
    override func main() {
        guard let to = to, !isCancelled else {
            result = .error("save error")
            return
        }
        do {
            try value?.write(to: to, atomically: true, encoding: .utf8)
            result = .success
//            result = .error("operation save error")
        } catch {
            result = .error(error.localizedDescription)
        }
    }
}

class SaveDataOperation: ResultOperation {
    var to: URL?
    var value: Data?
    
    override func main() {
        applog("operation save avatar")
        guard let to = to, !isCancelled, let value = value else {
            result = .error("save data error")
            return
        }
        do {
            try value.write(to: to)
            result = .success
//            result = .error("save data test error")
        } catch {
            result = .error(error.localizedDescription)
        }
    }
}

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

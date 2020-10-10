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

internal class ResultOperation: Operation{
    var result: SaveOperationResult?
    override func main() {
        result = .success
    }
}

internal class SaveStringOperation: ResultOperation {
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
        } catch {
            result = .error(error.localizedDescription)
        }
    }
}

internal enum SaveUserResult {
    case success
    case errorName(_ value: String)
    case errorDesc(_ value: String)
}

internal class SaveCompletionOperation: Operation {
    private var saveName: ResultOperation
    private var saveDesc: ResultOperation
    private var error: String = ""
    private(set) var result: SaveUserResult?

    init(nameOp: ResultOperation, descOp: ResultOperation) {
        saveName = nameOp
        saveDesc = descOp
        
        super.init()
    }
    
    override func main() {
        guard let nameRes = saveName.result else {
            result = .errorName("save name error")
            return
        }
        guard let descRes = saveDesc.result else {
            result = .errorDesc("save desc error")
            return
        }
        switch nameRes {
            case .error(let value):
                result = .errorName(value)
                return
            case .success:
                result = .success
        }
        
        switch descRes {
            case .error(let value):
                result = .errorDesc(value)
                return
            case .success:
                result = .success
        }
    }
}

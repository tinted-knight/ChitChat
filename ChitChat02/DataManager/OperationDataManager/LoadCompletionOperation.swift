//
//  LoadCompletionOperation.swift
//  ChitChat02
//
//  Created by Timun on 12.10.2020.
//  Copyright © 2020 TimunInc. All rights reserved.
//

import Foundation

enum LoadUserResult {
    case success(_ model: UserModel)
    case error(_ error: String)
}

class LoadCompletionOperation: Operation {
    private var userName: String?
    private var userDesc: String?
    private var error: String = ""
    private var loadName: LoadStringOperation
    private var loadDesc: LoadStringOperation
    private(set) var result: LoadUserResult?

    init(loadNameOp: LoadStringOperation, loadDescOp: LoadStringOperation) {
        loadName = loadNameOp
        loadDesc = loadDescOp
        super.init()
    }
    
    override func main() {
        guard let nameRes = loadName.result, let descRes = loadDesc.result else {
            result = .error("load common error")
            return
        }

        switch nameRes {
            case .success(let value):
                userName = value
            case .error(let value):
                result = .error(value)
                return
        }

        switch descRes {
            case .success(let value):
                userDesc = value
            case .error(let value):
                result = .error(value)
                return
        }

        if let name = userName, let desc = userDesc {
            result = .success(UserModel(name: name, description: desc))
        } else {
            result = .error("load common error")
        }
    }
}

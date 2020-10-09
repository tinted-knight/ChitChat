//
//  OperationDataManager.swift
//  ChitChat02
//
//  Created by Timun on 09.10.2020.
//  Copyright © 2020 TimunInc. All rights reserved.
//

import Foundation

class OperationDataManager: DataManager {
    private let queue = OperationQueue()
    var user: UserModel = newUser
    var delegate: DataManagerDelegate?

    func save(_ model: UserModel) {
    }
    
    func load() {
        let nameOp = loadOperation(from: nameUrl())
        let descOp = loadOperation(from: descriptionUrl())
        let loadCompletion = LoadCompletionOperation(
            loadNameOp: nameOp,
            loadDescOp: descOp
        )
        loadCompletion.completionBlock = { [weak self] in
            guard let result = loadCompletion.result else {
                self?.delegate?.onLoadError("load error")
                return
            }
            switch result {
                case .error(let value):
                    self?.delegate?.onLoadError(value)
                case .success(let value):
                    self?.delegate?.onLoaded(value)
                    self?.user = value
            }
        }
        loadCompletion.addDependency(nameOp)
        loadCompletion.addDependency(descOp)
        queue.addOperations([nameOp, descOp, loadCompletion], waitUntilFinished: false)
    }
    
    private func loadOperation(from: URL) -> LoadStringOperation {
        let operation = LoadStringOperation()
        operation.from = from
        return operation
    }

    private func storageUrl() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    private func nameUrl() -> URL {
        var url = storageUrl()
        url.appendPathComponent("user_name.txt")
        return url
    }

    private func descriptionUrl() -> URL {
        var url = storageUrl()
        url.appendPathComponent("user_description.txt")
        return url
    }
}

private enum SaveOperationResult {
    case success
    case error(value: String)
}

private class SaveStringOperation: Operation {
    var to: URL?
    var value: String?
    private(set) var result: SaveOperationResult?
    
    override func main() {
        guard let to = to, !isCancelled else {
            result = .error(value: "save error")
            return
        }
        do {
            try value?.write(to: to, atomically: true, encoding: .utf8)
        } catch {
            result = .error(value: error.localizedDescription)
        }
    }
}

private enum LoadStringResult {
    case success(_ value: String)
    case error(_ error: String)
}

private class LoadStringOperation: Operation {
    var from: URL?
    private(set) var result: LoadStringResult?
    
    override func main() {
        guard let from = from, !isCancelled else {
            result = .error("load error")
            return
        }
        do {
            let value = try String(contentsOf: from)
            result = .success(value)
        } catch {
            result = .error(error.localizedDescription)
        }
    }
}

private enum LoadUserResult {
    case success(_ model: UserModel)
    case error(_ error: String)
}

private class LoadCompletionOperation: Operation {
    var userName: String?
    var userDesc: String?
    var error: String?
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
            result = .error("load error")
            return
        }

        switch nameRes {
            case .success(let value):
                userName = value
            case .error(let value):
                error = value
        }

        switch descRes {
            case .success(let value):
                userDesc = value
            case .error(let value):
                error?.append(value)
        }

        if let error = error {
            result = .error(error)
            return
        }

        if let name = userName, let desc = userDesc {
            result = .success(UserModel(name: name, description: desc))
        }
    }
}

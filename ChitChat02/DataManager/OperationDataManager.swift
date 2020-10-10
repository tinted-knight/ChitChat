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
        let nameOperation = model.name != user.name ? saveOperation(model.name, to: nameUrl()) : ResultOperation()
        let descOperation = model.description != user.description ? saveOperation(model.description, to: descriptionUrl()) : ResultOperation()
        let saveCompletion = SaveCompletionOperation(
            nameOp: nameOperation,
            descOp: descOperation
        )
        saveCompletion.completionBlock = { [weak self] in
            applog("save completion")
            guard let result = saveCompletion.result else {
                self?.delegate?.onSaveError("save error")
                return
            }
            switch result {
                case .errorName(let value), .errorDesc(let value):
                    self?.delegate?.onSaveError(value)
                case .success:
                    self?.delegate?.onSaved()
                    self?.user = model
            }
        }
        saveCompletion.addDependency(nameOperation)
        saveCompletion.addDependency(descOperation)
        queue.addOperations([nameOperation, descOperation, saveCompletion], waitUntilFinished: false)
    }
    
    private func saveOperation(_ value: String, to: URL) -> ResultOperation {
        let operation = SaveStringOperation()
        operation.value = value
        operation.to = to
        return operation
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
    case error(_ value: String)
}

private class ResultOperation: Operation{
    var result: SaveOperationResult?
    override func main() {
        applog("default success")
        result = .success
    }
}

private class SaveStringOperation: ResultOperation {
    var to: URL?
    var value: String?
    
    override func main() {
        applog("save string main")
        guard let to = to, !isCancelled else {
            applog("canceled or to = nil")
            result = .error("save error")
            return
        }
        do {
            try value?.write(to: to, atomically: true, encoding: .utf8)
            result = .success
        } catch {
            applog("catch \(error.localizedDescription)")
            result = .error(error.localizedDescription)
        }
    }
}

private enum SaveUserResult {
    case success
    case errorName(_ value: String)
    case errorDesc(_ value: String)
}

private class SaveCompletionOperation: Operation {
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
            applog("save name guard")
            result = .errorName("save name error")
            return
        }
        guard let descRes = saveDesc.result else {
            applog("save desc guard")
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
            result = .error("load error")
            return
        }

        switch nameRes {
            case .success(let value):
                userName = value
            case .error(let value):
                error.append(value)
        }

        switch descRes {
            case .success(let value):
                userDesc = value
            case .error(let value):
                error.append(value)
        }

        if !error.isEmpty {
            result = .error(error)
            return
        }

        if let name = userName, let desc = userDesc {
            result = .success(UserModel(name: name, description: desc))
        } else {
            result = .error("load error")
        }
    }
}

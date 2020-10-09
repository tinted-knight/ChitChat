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
            applog("all completion")
            guard let name = loadCompletion.userName, let desc = loadCompletion.userDesc else {
                self?.delegate?.onLoadError(loadCompletion.error)
                return
            }
            let loaded = UserModel(name: name, description: desc)
            self?.user = loaded
            self?.delegate?.onLoaded(loaded)
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

private class SaveStringOperation: Operation {
    var saveTo: URL?
    var value: String?
    
    override func main() {
    }
}

private class LoadStringOperation: Operation {
    var from: URL?
    var error: String?
    var value: String?
    
    override func main() {
        guard let from = from, !isCancelled else {
            error = "load error"
            return
        }
        do {
            let value = try String(contentsOf: from)
            self.value = value
        } catch {
            self.error = error.localizedDescription
        }
    }
}

private class LoadCompletionOperation: Operation {
    var userName: String?
    var userDesc: String?
    var error: String = ""
    private var loadName: LoadStringOperation
    private var loadDesc: LoadStringOperation

    init(loadNameOp: LoadStringOperation, loadDescOp: LoadStringOperation) {
        loadName = loadNameOp
        loadDesc = loadDescOp
        super.init()
    }
    
    override func main() {
        guard let name = loadName.value, let desc = loadDesc.value else {
            let summary: String = loadName.error ?? "" + (loadDesc.error ?? "")
            error = summary
            return
        }
        userName = name
        userDesc = desc
    }
}

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

    func save(_ model: UserModel, avatar: Data?) {
        let nameOperation = model.name != user.name ? saveOperation(model.name, to: nameUrl()) : ResultOperation()
        let descOperation = model.description != user.description ? saveOperation(model.description, to: descriptionUrl()) : ResultOperation()
        let saveCompletion = SaveCompletionOperation(
            nameOp: nameOperation,
            descOp: descOperation
        )
        saveCompletion.completionBlock = { [weak self] in
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
                case .nameError(let value):
                    self?.delegate?.onLoadError(value)
                case .descError(let value):
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

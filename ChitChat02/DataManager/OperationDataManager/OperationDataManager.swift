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
    var delegate: DataManagerDelegate?

    private var nameOperation: ResultOperation = ResultOperation()
    private var descOperation: ResultOperation = ResultOperation()
    private var avatarOperation: ResultOperation = ResultOperation()
    
    func save(name: String?, description: String?, avatar: Data?) {
        applog("operation save")
        if let name = name {
            nameOperation  = saveStringOperation(name, to: nameUrl())
        }
        
        if let description = description {
            descOperation = saveStringOperation(description, to: descriptionUrl())
        }
        
        if let avatar = avatar {
            avatarOperation = saveDataOperation(avatar, to: avatarUrl())
        }
        
        let saveCompletion = SaveCompletionOperation(
            nameOp: nameOperation,
            descOp: descOperation,
            avatarOp: avatarOperation
        )
        
        saveCompletion.completionBlock = { [weak self] in
            guard let result = saveCompletion.result else {
                self?.delegate?.onSaveError("save error")
                return
            }
            switch result {
                case .error(let value):
                    self?.delegate?.onSaveError(value)
                case .success:
                    self?.delegate?.onSaved()
            }
        }
        
        saveCompletion.addDependency(nameOperation)
        saveCompletion.addDependency(descOperation)
        saveCompletion.addDependency(avatarOperation)
        queue.addOperations(
            [nameOperation, descOperation, avatarOperation, saveCompletion],
            waitUntilFinished: false
        )
    }
    
    private func saveStringOperation(_ value: String, to: URL) -> ResultOperation {
        let operation = SaveStringOperation()
        operation.value = value
        operation.to = to
        return operation
    }
    
    private func saveDataOperation(_ value: Data, to: URL) -> ResultOperation {
        let operation = SaveDataOperation()
        operation.value = value
        operation.to = to
        return operation
    }
    
    func load() {
        applog("operation load")
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
}

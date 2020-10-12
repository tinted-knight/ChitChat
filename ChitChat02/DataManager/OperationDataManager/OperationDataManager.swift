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
    
    func save(name: String?, description: String?, avatar: Data?) {
        applog("operation save")
        if let name = name {
            nameOperation  = saveOperation(name, to: nameUrl())
        }
        if let description = description {
            descOperation = saveOperation(description, to: descriptionUrl())
        }
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
                case .errorName(let value):
                    self?.delegate?.onSaveError(value)
                case .errorDesc(let value):
                    self?.delegate?.onSaveError(value)
                case .success:
                    self?.delegate?.onSaved()
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
                case .nameError(let value):
                    self?.delegate?.onLoadError(value)
                case .descError(let value):
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

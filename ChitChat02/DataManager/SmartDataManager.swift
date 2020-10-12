//
//  OptionalDataManager.swift
//  ChitChat02
//
//  Created by Timun on 12.10.2020.
//  Copyright © 2020 TimunInc. All rights reserved.
//

import Foundation

enum DataManagerType { case gcd, operation }

class SmartDataManager {
    private lazy var gcdDataManager = GCDDataManager()
    private lazy var operationDataManager = OperationDataManager()

    private var dataManagerType: DataManagerType
    
    var delegate: DataManagerDelegate? = nil
    
    var user: UserModel = newUser
    private var lastSavedUser: UserModel? = nil
    private var lastSavedAvatar: Data? = nil

    init(dataManagerType: DataManagerType = .gcd) {
        self.dataManagerType = dataManagerType
        gcdDataManager.delegate = self
        operationDataManager.delegate = self
    }
    
    func save(user model: UserModel, avatar: Data? = nil, with type: DataManagerType? = nil) {
        if let type = type { self.dataManagerType = type }
        
        lastSavedUser = model
        lastSavedAvatar = avatar
        
        dataManager.save(model, avatar: avatar)
    }
    
    func load(with type: DataManagerType? = nil) {
        if let type = type { self.dataManagerType = type }
        
        switch self.dataManagerType {
            case .gcd:
                gcdDataManager.load()
            case .operation:
                operationDataManager.load()
        }
    }
    
    // retry save operation
    func retry() {
        guard let user = lastSavedUser else { return }
        
        save(user: user, avatar: lastSavedAvatar)
    }
    
    private var dataManager: DataManager {
        switch dataManagerType {
            case .gcd:
                return gcdDataManager
            case .operation:
                return operationDataManager
        }
    }
}

extension SmartDataManager: DataManagerDelegate {
    func onLoaded(_ model: UserModel) {
        user = model
        delegate?.onLoaded(model)
    }
    
    func onLoadError(_ message: String) {
        delegate?.onLoadError(message)
    }
    
    func onSaved(_ model: UserModel) {
        user = model
        delegate?.onSaved(model)
    }
    
    func onSaveError(_ message: String) {
        delegate?.onSaveError(message)
    }
}

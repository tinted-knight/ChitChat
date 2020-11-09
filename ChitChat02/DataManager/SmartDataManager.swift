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
    
    private var dataManager: IDataManager {
        switch dataManagerType {
        case .gcd:
            return gcdDataManager
        case .operation:
            return operationDataManager
        }
    }

    var delegate: IDataManagerDelegate?
    
    var user: UserModel = newUser
    private var lastSavedUser: UserModel?
    private var lastSavedAvatar: Data?

    init(dataManagerType: DataManagerType = .gcd) {
        self.dataManagerType = dataManagerType
        gcdDataManager.delegate = self
        operationDataManager.delegate = self
    }
    
    func save(user model: UserModel, avatar: Data? = nil, with type: DataManagerType? = nil) {
        applog("smart will save \(model)")
        if let type = type { self.dataManagerType = type }
        
        lastSavedUser = model
        lastSavedAvatar = avatar
        
        dataManager.save(
            name: model.name != user.name ? model.name : nil,
            description: model.description != user.description ? model.description : nil,
            avatar: avatar
        )
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
    
    func isValid(name: String?, description: String) -> Bool {
        guard let name = name else { return false }
        guard !name.isEmpty, !description.isEmpty else { return false }
        return true
    }
    
    func wasModified(name: String?, description: String) -> Bool {
        guard isValid(name: name, description: description) else { return false }
        return name != user.name || description != user.description
    }
}

extension SmartDataManager: IDataManagerDelegate {
    func onLoaded(_ model: UserModel) {
        applog("smart load, \(model)")
        user = model
        delegate?.onLoaded(model)
    }
    
    func onLoadError(_ message: String) {
        delegate?.onLoadError(message)
    }
    
    func onSaved() {
        applog("smart saved")
        delegate?.onSaved()
    }
    
    func onSaveError(_ message: String) {
        delegate?.onSaveError(message)
    }
}

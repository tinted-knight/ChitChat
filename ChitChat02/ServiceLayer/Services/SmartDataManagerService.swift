//
//  OptionalDataManager.swift
//  ChitChat02
//
//  Created by Timun on 12.10.2020.
//  Copyright © 2020 TimunInc. All rights reserved.
//

import Foundation

protocol IDataManagerService {
    var delegate: IDataManagerDelegate? { get set }

    var user: UserModel { get }

    func save(user model: UserModel, avatar: Data?, with type: DataManagerType)

    func load()

    func retry()
}

enum DataManagerType { case gcd, operation }

class SmartDataManagerService: IDataManagerService {
    private var gcdDataManager: IDataManager
    private var operationDataManager: IDataManager
    
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

    init(gcdManager: IDataManager, operationManager: IDataManager) {
        self.gcdDataManager = gcdManager
        self.operationDataManager = operationManager
        
        self.dataManagerType = .operation

        self.gcdDataManager.delegate = self
        self.operationDataManager.delegate = self
    }

    func save(user model: UserModel, avatar: Data? = nil, with type: DataManagerType) {
        applog("smart will save \(model)")
        
        lastSavedUser = model
        lastSavedAvatar = avatar
        
        self.dataManagerType = type
        dataManager.save(
            name: model.name != user.name ? model.name : nil,
            description: model.description != user.description ? model.description : nil,
            avatar: avatar
        )
    }
    
    func load() {
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
        
        save(user: user, avatar: lastSavedAvatar, with: dataManagerType)
    }
}

extension SmartDataManagerService: IDataManagerDelegate {
    func onLoaded(_ model: UserModel) {
        applog("smart load, \(model)")
        user = model
        delegate?.onLoaded(model)
    }
    
    func onLoadError(_ message: String) {
        applog("smart load error")
        delegate?.onLoadError(message)
    }
    
    func onSaved() {
        applog("smart saved")
        delegate?.onSaved()
    }
    
    func onSaveError(_ message: String) {
        applog("smart save error")
        delegate?.onSaveError(message)
    }
}

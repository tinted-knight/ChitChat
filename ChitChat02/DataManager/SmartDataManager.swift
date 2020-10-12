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
    
    var delegate: DataManagerDelegate? {
        set {
            gcdDataManager.delegate = newValue
            operationDataManager.delegate = newValue
        }
        get { nil }
    }

    init(dataManagerType: DataManagerType = .gcd) {
        self.dataManagerType = dataManagerType
    }
    
    func save(user model: UserModel, avatar: Data? = nil, with type: DataManagerType? = nil) {
        if let type = type { self.dataManagerType = type }
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
    
    var user: UserModel {
        switch dataManagerType {
            case .gcd:
                return gcdDataManager.user
            case .operation:
                return operationDataManager.user
        }
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

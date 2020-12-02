//
//  DataManagerMocks.swift
//  ChitChat02Tests
//
//  Created by Timun on 28.11.2020.
//  Copyright © 2020 TimunInc. All rights reserved.
//

@testable import ChitChat02
import Foundation

let userLoadStub = UserModel(name: "Ostap", description: "Son", avatar: nil)

class GCDMock: IDataManager {
    var delegate: IDataManagerDelegate?
    
    var saveCalls = 0
    var loadCalls = 0
    var saveName: String?
    var saveDescription: String?
    
    func save(name: String?, description: String?, avatar: Data?) {
        saveCalls += 1
        saveName = name
        saveDescription = description
        delegate?.onSaved()
    }
    
    func load() {
        loadCalls += 1
        delegate?.onLoaded(userLoadStub)
    }
}

class OperationMock: IDataManager {
    var delegate: IDataManagerDelegate?
    
    var saveCalls = 0
    var loadCalls = 0
    var saveName: String?
    var saveDescription: String?

    func save(name: String?, description: String?, avatar: Data?) {
        saveCalls += 1
        saveName = name
        saveDescription = description
        delegate?.onSaved()
    }
    
    func load() {
        loadCalls += 1
        delegate?.onLoaded(userLoadStub)
    }
}

class DelegateStub: IDataManagerDelegate {
    
    var onLoadedCalls = 0
    var onLoadedUser: UserModel?
    
    var onLoadErrorCalls = 0
    var onLoadErrorMessage: String?
    
    var onSavedCalls = 0
    
    var onSaveErrorCalls = 0
    var onSaveErrorMessage: String?
    
    func onLoaded(_ model: UserModel) {
        onLoadedCalls += 1
        onLoadedUser = model
    }
    
    func onLoadError(_ message: String) {
        onLoadErrorCalls += 1
        onLoadErrorMessage = message
    }
    
    func onSaved() {
        onSavedCalls += 1
    }
    
    func onSaveError(_ message: String) {
        onSaveErrorCalls += 1
        onSaveErrorMessage = message
    }
}

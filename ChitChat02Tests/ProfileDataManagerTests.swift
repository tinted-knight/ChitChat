//
//  ProfileDataManagerTests.swift
//  ChitChat02Tests
//
//  Created by Timun on 28.11.2020.
//  Copyright © 2020 TimunInc. All rights reserved.
//

@testable import ChitChat02
import XCTest

class ProfileDataManagerTests: XCTestCase {
    lazy var gcdMock = GCDMock()
    lazy var  operationMock = OperationMock()
    lazy var  dataManager = SmartDataManagerService(gcdManager: self.gcdMock,
                                              operationManager: self.operationMock)

    func testDefaultLoad() throws {
        // Act
        dataManager.load()
        
        // Assert
        XCTAssertEqual(operationMock.loadCalls, 1)
        XCTAssertEqual(gcdMock.loadCalls, 0)
    }
    
    func testGCDLoad() throws {
        // Arrange
        let userStub = UserModel(name: "Ostap", description: "Son", avatar: nil)

        // Act
        dataManager.save(user: userStub, with: .gcd)
        dataManager.load()

        // Assert
        XCTAssertEqual(gcdMock.loadCalls, 1)
        XCTAssertEqual(operationMock.loadCalls, 0)
    }

    func testGCDSave() throws {
        // Arrange
        let userStub = UserModel(name: "Ostap", description: "Son", avatar: nil)
        
        // Act
        dataManager.save(user: userStub, with: .gcd)
        
        // Assert
        XCTAssertEqual(gcdMock.saveCalls, 1)
        XCTAssertEqual(gcdMock.saveName, userStub.name)
        XCTAssertEqual(gcdMock.saveDescription, userStub.description)

        XCTAssertEqual(operationMock.saveCalls, 0)
    }

    func testOperationSave() throws {
        // Arrange
        let userStub = UserModel(name: "Ostap", description: "Son", avatar: nil)
        
        // Act
        dataManager.save(user: userStub, with: .operation)
        
        // Assert
        XCTAssertEqual(operationMock.saveCalls, 1)
        XCTAssertEqual(operationMock.saveName, userStub.name)
        XCTAssertEqual(operationMock.saveDescription, userStub.description)

        XCTAssertEqual(gcdMock.saveCalls, 0)
    }
    
    func testOperationDelegate() throws {
        // Arrange
        let delegate = DelegateStub()
        dataManager.delegate = delegate
        let userStub = UserModel(name: "Ostap", description: "Son", avatar: nil)

        // Act
        dataManager.load()
        dataManager.save(user: userStub, with: .operation)
        
        // Assert
        // delegate has been set
        XCTAssertNotNil(operationMock.delegate)
        // load
        XCTAssertEqual(delegate.onLoadedCalls, 1)
        XCTAssertNotNil(delegate.onLoadedUser)
        let user = delegate.onLoadedUser!
        XCTAssertEqual(user.name, userLoadStub.name)
        // save
        XCTAssertEqual(delegate.onSavedCalls, 1)
    }

    func testGCDDelegate() throws {
        // Arrange
        let delegate = DelegateStub()
        dataManager.delegate = delegate
        let userStub = UserModel(name: "Ostap", description: "Son", avatar: nil)

        // Act
        dataManager.save(user: userStub, with: .gcd)
        dataManager.load()
        
        // Assert
        // delegate has been set
        XCTAssertNotNil(gcdMock.delegate)
        // load
        XCTAssertEqual(delegate.onLoadedCalls, 1)
        XCTAssertNotNil(delegate.onLoadedUser)
        let user = delegate.onLoadedUser!
        XCTAssertEqual(user.name, userLoadStub.name)
        // save
        XCTAssertEqual(delegate.onSavedCalls, 1)
    }
}

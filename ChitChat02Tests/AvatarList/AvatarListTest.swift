//
//  AvatarListTest.swift
//  ChitChat02Tests
//
//  Created by Timun on 30.11.2020.
//  Copyright © 2020 TimunInc. All rights reserved.
//

@testable import ChitChat02
import XCTest

class AvatarListTests: XCTestCase {

    private lazy var avatarManagerMock = AvatarManagerMock()
    private lazy var avatarService = AvatarService(manager: avatarManagerMock)

    func testLoadList() {
        // Arrange
        let avatarListUrlString = "https://picsum.photos/v2/list?page=1&limit=100"
        // Act
        avatarService.getList { (_) in }
        // Assert
        XCTAssertEqual(avatarManagerMock.sendCalls, 1)
        XCTAssertEqual(avatarManagerMock.request?.urlRequest?.url?.absoluteString, avatarListUrlString)
    }
    
    func testLoadSingleImage() {
        // Arrange
        let imageUrlString = "https://picsum.photos/id/1001/200/200"
        let imageId = "1001"
        // Act
        avatarService.loadImage(imageId) { (_) in }
        //Assert
        XCTAssertEqual(avatarManagerMock.sendCalls, 1)
        XCTAssertEqual(avatarManagerMock.request?.urlRequest?.url?.absoluteString, imageUrlString)
    }
}

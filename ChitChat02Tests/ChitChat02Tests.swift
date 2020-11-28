//
//  ChitChat02Tests.swift
//  ChitChat02Tests
//
//  Created by Timun on 28.11.2020.
//  Copyright © 2020 TimunInc. All rights reserved.
//

@testable import ChitChat02
import XCTest

class ChitChat02Tests: XCTestCase {
    func testLocalStorage() throws {
        // Arrange
        let localStorageMock = LocalStorageMock()
        let remoteChannelMock = RemoteChannelMock()
        let channelService = ChannelService(local: localStorageMock, remote: remoteChannelMock)

        // Act
        channelService.setup { }

        // Assert
        XCTAssertEqual(localStorageMock.createContainerCalls, 1)
    }
}

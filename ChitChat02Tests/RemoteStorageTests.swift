//
//  ChitChat02Tests.swift
//  ChitChat02Tests
//
//  Created by Timun on 28.11.2020.
//  Copyright © 2020 TimunInc. All rights reserved.
//

@testable import ChitChat02
import XCTest

class RemoteStorageTests: XCTestCase {
    
    lazy var localStorageMock = LocalStorageMock()
    lazy var remoteChannelMock = RemoteChannelMock()
    lazy var channelService = ChannelService(local: self.localStorageMock,
                                        remote: self.remoteChannelMock)

    lazy var channelStub = Channel(identifier: "1001",
                                   name: "Каналья",
                                   lastMessage: "LastMessage",
                                   lastActivity: Date(timeIntervalSince1970: 1606582800))

    func testRemoteAdd() throws {
        // Act
        channelService.addChannel(channelStub.name)
        
        // Assert
        XCTAssertEqual(remoteChannelMock.addChannelCalls, 1)
        XCTAssertEqual(remoteChannelMock.addName, channelStub.name)
    }

    func testRemoteDelete() throws {
        // Act
        channelService.deleteChannel(channelStub.identifier)
        
        // Assert
        XCTAssertEqual(remoteChannelMock.deleteChannelCalls, 1)
        XCTAssertEqual(remoteChannelMock.deleteId, channelStub.identifier)
    }
    
    func testRemoteLoad() throws {
        // Act
        channelService.fetchRemote()
        
        //Assert
        XCTAssertEqual(remoteChannelMock.loadOnceCalls, 1)
    }
}

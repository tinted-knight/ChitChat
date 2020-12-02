//
//  RemoteChannelMock.swift
//  ChitChat02Tests
//
//  Created by Timun on 28.11.2020.
//  Copyright © 2020 TimunInc. All rights reserved.
//

@testable import ChitChat02
import Foundation

class RemoteChannelMock: IRemoteChannelStorage {
    
    var loadChannelListCalls = 0
    var loadOnceCalls = 0
    
    var addChannelCalls = 0
    var addName: String?
    
    var deleteChannelCalls = 0
    var deleteId: String?
    
    func loadChannelList(onAdded: @escaping (Channel) -> Void,
                         onModified: @escaping (Channel) -> Void,
                         onRemoved: @escaping (Channel) -> Void,
                         onError: @escaping (String) -> Void) {
        loadChannelListCalls += 1
    }
    
    func loadOnce(onData: @escaping ([Channel]) -> Void) {
        loadOnceCalls += 1
    }
    
    func addChannel(name: String, completion: @escaping (Bool) -> Void) {
        addChannelCalls += 1
        addName = name
    }
    
    func deleteChannel(id: String, completion: @escaping (Bool) -> Void) {
        deleteChannelCalls += 1
        deleteId = id
    }
}

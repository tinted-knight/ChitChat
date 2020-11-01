//
//  ChannelsManager.swift
//  ChitChat02
//
//  Created by Timun on 17.10.2020.
//  Copyright © 2020 TimunInc. All rights reserved.
//

import Foundation
import Firebase

class FirestoreChannelManager: FirestoreDataManager, ChannelsManager {
    private var channels: CollectionReference {
        return db.collection(Channel.path)
    }

    func loadChannelList(onData: @escaping ([Channel]) -> Void, onError: @escaping (String) -> Void) {
        channels.order(by: Channel.name, descending: false).getDocuments { (snapshot, error) in
            if let error = error {
                onError(error.localizedDescription)
                return
            }
            
            let channels: [Channel]  = snapshot?.documents
                .filter({ document in
                    guard let name = document.data()[Channel.name] as? String,
                        !name.isEmpty else { return false }
                    return true
                })
                .compactMap({ document in Channel(from: document) }) ?? []

            onData(channels)
        }
    }
    
    func getChannel(id channelId: String, onData: @escaping (Channel) -> Void, onError: @escaping (String) -> Void) {
        Log.oldschool(#function)
        channels.document(channelId).getDocument { (snapshot, error) in
            guard let snapshot = snapshot else { fatalError("channel is nil") }
            if let error = error {
                onError(error.localizedDescription)
                return
            }
            if let channel = Channel(from: snapshot) {
                Log.oldschool("getChannel::onData, \(channel.name)")
                onData(channel)
            }
        }
    }
    
    func addChannel(name: String) {
        let newChannelData: [String: Any] = [
            Channel.name: name,
            Channel.lastActivity: Timestamp(date: Date())
        ]
        channels.addDocument(data: newChannelData) { (error) in
            if let error = error {
                Log.fire("creating channel error: \(error.localizedDescription)")
                return
            } else {
                Log.fire("creating channel success")
            }
        }
    }
}

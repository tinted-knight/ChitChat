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
        channels.addSnapshotListener { (snapshot, error) in
            if let error = error {
                onError(error.localizedDescription)
                return
            }
            
            let channels: [Channel]  = snapshot?.documents
                .filter({ document in
                    guard let name = document.data()[Channel.name] as? String, !name.isEmpty else { return false }
                    return true
                })
                .map({ document in
                    let id: String = document.documentID
                    let name: String = document.data()[Channel.name] as? String ?? "noname"
                    let lastMessage: String? = document.data()[Channel.lastMessage] as? String
                    let timestamp: Timestamp? = document.data()[Channel.lastActivity] as? Timestamp
                    let lastActivity: Date? = timestamp?.dateValue()
                    
                    return Channel(
                        indentifier: id,
                        name: name,
                        lastMessage: lastMessage,
                        lastActivity: lastActivity)
                }) ?? []

            onData(channels)
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

//
//  RemoteChannelStorage.swift
//  ChitChat02
//
//  Created by Timun on 08.11.2020.
//  Copyright © 2020 TimunInc. All rights reserved.
//

import Foundation
import Firebase

protocol IRemoteChannelStorage {
    func loadChannelList(onAdded: @escaping (Channel) -> Void,
                         onModified: @escaping (Channel) -> Void,
                         onRemoved: @escaping (Channel) -> Void,
                         onError: @escaping (String) -> Void)
    func loadOnce(onData: @escaping ([Channel]) -> Void)
    func addChannel(name: String, completion: @escaping (Bool) -> Void)
    func deleteChannel(id: String, completion: @escaping (Bool) -> Void)
}

class RemoteChannelStorage: IRemoteChannelStorage {

    lazy var db = Firestore.firestore()

    private var channels: CollectionReference {
        return db.collection(Channel.path)
    }

    func loadChannelList(onAdded: @escaping (Channel) -> Void,
                         onModified: @escaping (Channel) -> Void,
                         onRemoved: @escaping (Channel) -> Void,
                         onError: @escaping (String) -> Void) {
        channels.order(by: Channel.name, descending: false).addSnapshotListener { (snapshot, error) in
            if let error = error {
                onError(error.localizedDescription)
                return
            }
            guard let snapshot = snapshot else { return }

            snapshot.documentChanges.forEach { (diff) in
                guard let channel = Channel(from: diff.document) else { return }
                switch diff.type {
                case .added:
                    onAdded(channel)
                case .modified:
                    onModified(channel)
                case .removed:
                    onRemoved(channel)
                }
            }
        }
    }
    
    func loadOnce(onData: @escaping ([Channel]) -> Void) {
        channels.order(by: Channel.name, descending: false).getDocuments { (snapshot, error) in
            if let error = error {
                Log.coredata(error.localizedDescription)
                return
            }
            guard let snapshot = snapshot else { return }
            let channels: [Channel] = snapshot.documents.compactMap { Channel(from: $0) }
            onData(channels)
        }
    }
    
    func getChannel(id channelId: String, onData: @escaping (Channel) -> Void, onError: @escaping (String) -> Void) {
        Log.coredata(#function)
        channels.document(channelId).getDocument { (snapshot, error) in
            guard let snapshot = snapshot else { fatalError("channel is nil") }
            if let error = error {
                onError(error.localizedDescription)
                return
            }
            if let channel = Channel(from: snapshot) {
                Log.coredata("getChannel::onData, \(channel.name)")
                onData(channel)
            }
        }
    }
    
    func addChannel(name: String, completion: @escaping (Bool) -> Void) {
        let newChannelData: [String: Any] = [
            Channel.name: name,
            Channel.lastActivity: Timestamp(date: Date())
        ]
        channels.addDocument(data: newChannelData) { (error) in
            if let error = error {
                Log.fire("creating channel error: \(error.localizedDescription)")
                completion(false)
                return
            } else {
                Log.fire("creating channel success")
                completion(true)
            }
        }
    }
    
    func deleteChannel(id: String, completion: @escaping (Bool) -> Void) {
        channels.document(id).delete { (error) in
            if error != nil {
                Log.fire("delete channel error")
                completion(false)
                return
            } else {
                Log.fire("delete channel success")
                completion(true)
            }
        }
    }
}

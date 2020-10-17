//
//  FirestoreDataManager.swift
//  ChitChat02
//
//  Created by Timun on 17.10.2020.
//  Copyright © 2020 TimunInc. All rights reserved.
//

import Foundation
import Firebase

protocol FirestoreDelegate {
    func onData(_ channels: [Channel])
}

struct Channel {
    let indentifier: String
    let name: String
    let lastMessage: String?
    let lastActivity: Date?
}

struct Message {
    let content: String
    let created: Date
    let senderId: String
    let senderName: String
}

class FirestoreDataManager {
    private lazy var db = Firestore.firestore()
    private lazy var reference = db.collection("channels")
    
    var delegate: FirestoreDelegate?
    
    func load() {
        reference.addSnapshotListener { [weak self] (snapshot, error) in
            let channels: [Channel]  = snapshot?.documents
                .filter({ document in
                    guard let name = document.data()["name"] as? String, !name.isEmpty else { return false }
                    return true
                })
                .map({ document in
                    let id: String = document.documentID
                    let name: String = document.data()["name"] as? String ?? "noname"
                    let lastMessage: String? = document.data()["lastMessage"] as? String
                    let timestamp: Timestamp? = document.data()["lastActivity"] as? Timestamp
                    let lastActivity: Date? = timestamp?.dateValue()
                    
                    return Channel(
                        indentifier: id,
                        name: name,
                        lastMessage: lastMessage,
                        lastActivity: lastActivity)
                }) ?? []

            channels.forEach { (channel) in
                print("id = \(channel.indentifier), name = \(channel.name)")
            }
            
            self?.delegate?.onData(channels)
        }
    }
}

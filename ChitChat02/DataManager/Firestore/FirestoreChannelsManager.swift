//
//  ChannelsManager.swift
//  ChitChat02
//
//  Created by Timun on 17.10.2020.
//  Copyright © 2020 TimunInc. All rights reserved.
//

import Foundation
import Firebase
import CoreData

class FirestoreChannelManager: FirestoreDataManager, ChannelsManager {
    private var channels: CollectionReference {
        return db.collection(Channel.path)
    }

    private let viewContext: NSManagedObjectContext
    
    init(with context: NSManagedObjectContext) {
        self.viewContext = context
    }
    
    lazy var frc: NSFetchedResultsController<ChannelEntity> = {
        let sortChannels = NSSortDescriptor(key: "name", ascending: true)
        let frChannels = NSFetchRequest<ChannelEntity>(entityName: "ChannelEntity")
        frChannels.sortDescriptors = [sortChannels]
        
        return NSFetchedResultsController(fetchRequest: frChannels,
                                          managedObjectContext: self.viewContext,
                                          sectionNameKeyPath: nil,
                                          cacheName: nil)
    }()

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

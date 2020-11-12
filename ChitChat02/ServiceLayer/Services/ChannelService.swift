//
//  SmartChannelManager.swift
//  ChitChat02
//
//  Created by Timun on 01.11.2020.
//  Copyright © 2020 TimunInc. All rights reserved.
//

import Foundation
import CoreData

protocol IChannelService {
    var frc: NSFetchedResultsController<ChannelEntity> { get }
    
    func setup(completion: @escaping () -> Void)
    func fetchRemote()
    func addChannel(_ name: String)
    func deleteChannel(_ channel: ChannelEntity)
}

class ChannelService: IChannelService {
    private let localStorage: IStorage
    private let remote: IRemoteChannelStorage

    private var firstStart = true

    init(local: IStorage, remote: IRemoteChannelStorage) {
        self.localStorage = local
        self.remote = remote
    }

    func setup(completion: @escaping () -> Void) {
        localStorage.createContainer {
            completion()
        }
    }
    
    lazy var frc: NSFetchedResultsController<ChannelEntity> = {
        guard let viewContext = self.localStorage.viewContext else { fatalError() }
        
        let sortChannels = NSSortDescriptor(key: "name", ascending: true)
        let frChannels = NSFetchRequest<ChannelEntity>(entityName: "ChannelEntity")
        frChannels.sortDescriptors = [sortChannels]
        
        return NSFetchedResultsController(fetchRequest: frChannels,
                                          managedObjectContext: viewContext,
                                          sectionNameKeyPath: nil,
                                          cacheName: nil)
    }()
    
    func fetchRemote() {
        // Идея: создание экземпляра менеджера происходит один раз - при старте приложения
        // первый раз при вызове метода fetchRemote() проверям __одноразовым запросом__,
        // есть ли в БД каналы, которых нет в ответе firebase и удаляем их из БД.
        // После удаления вешаем snapshotListener на firebase - уже должна приходить
        // информация об удалённых каналах в снэпшотах

        // вообще по идее если этот метод вызывать только один раз (сейчас так и есть),
        // то можно обойтись без флага firstStart
//        if firstStart {
        remote.loadOnce { [weak self] (channels) in
            self?.lookForDeleted(in: channels)
            self?.channelsListener()
        }
//        } else {
//            loadChannels()
//        }
    }
    
    private func channelsListener() {
        remote.loadChannelList(
            onAdded: { [weak self] (channel) in
                Log.coredata("fetchRemote channels, added \(channel.name), \(channel.lastMessage ?? "nil")")
                self?.insert(channel)
            }, onModified: { [weak self] (channel) in
                Log.coredata("fetchRemote channels, modified \(channel.name), \(channel.lastMessage ?? "")")
                self?.updateChannel(with: channel.identifier, message: channel.lastMessage, activity: channel.lastActivity)
            }, onRemoved: { [weak self] (channel) in
                Log.coredata("fetchRemote channels, removed \(channel.name)")
                self?.deleteFromDB(with: channel.identifier)
            }, onError: onError(_:))
    }
    
    func addChannel(_ name: String) {
        remote.addChannel(name: name) { (success) in
            Log.coredata("add channel \(success)")
        }
    }
    
    func deleteChannel(_ channel: ChannelEntity) {
        remote.deleteChannel(id: channel.identifier) { (success) in
            Log.coredata("delete channel \(success)")
        }
    }
    
    private func lookForDeleted(in channels: [Channel]) {
        guard let viewContext = self.localStorage.viewContext else { fatalError() }
        
        let identifiers = channels.map { $0.identifier }
        let request: NSFetchRequest<ChannelEntity> = ChannelEntity.fetchRequest()
        do {
            let fromDb = try viewContext.fetch(request)
            fromDb.filter { (entity) -> Bool in
                !identifiers.contains(entity.identifier)
            }.forEach { (entity) in
                Log.coredata("ready to delete channel \(entity.name)")
                viewContext.delete(entity)
            }
            localStorage.performDelete()
            firstStart = false
        } catch { fatalError("error while looking for deleted, \(error.localizedDescription)") }
    }
    
    private func deleteFromDB(with identifier: String) {
        guard let viewContext = self.localStorage.viewContext else { fatalError() }
        
        let request: NSFetchRequest<ChannelEntity> = ChannelEntity.fetchRequest()
        request.predicate = NSPredicate(format: "identifier == %@", identifier)
        request.fetchLimit = 1
        do {
            let sacrifice = try viewContext.fetch(request)
            if !sacrifice.isEmpty {
                Log.coredata("deleting channel \(sacrifice[0].name)")
                viewContext.delete(sacrifice[0])
                localStorage.performDelete()
            }
        } catch { fatalError("cannot fetch channel for deletion") }
    }
    
    private func insert(_ channel: Channel) {
        localStorage.saveInBackground { (context) in
            context.insert(ChannelEntity(from: channel, in: context))
        }
    }
    
    private func updateChannel(with identifier: String, message: String?, activity: Date?) {
        guard let viewContext = self.localStorage.viewContext else { fatalError() }
        
        let request: NSFetchRequest<ChannelEntity> = ChannelEntity.fetchRequest()
        request.predicate = NSPredicate(format: "identifier == %@", identifier)
        request.fetchLimit = 1
        do {
            let toUpdate = try viewContext.fetch(request)
            if !toUpdate.isEmpty {
                toUpdate[0].lastMessage = message
                toUpdate[0].lastActivity = activity
                localStorage.saveContext()
            }
        } catch { fatalError("cannot fetch channel for update") }
    }
    
    private func onError(_ message: String) {
        Log.coredata(message)
    }
}

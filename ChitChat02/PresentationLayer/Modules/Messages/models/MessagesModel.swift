//
//  MessagesModel.swift
//  ChitChat02
//
//  Created by Timun on 08.11.2020.
//  Copyright © 2020 TimunInc. All rights reserved.
//

import Foundation
import CoreData

protocol IMessagesModel {
    var channel: ChannelEntity { get }
    
    var frc: NSFetchedResultsController<MessageEntity> { get }
    
    var delegate: IMessageModelDelegate? { get set }
    
    var userName: String { get }
    
    func cellModel(for message: MessageEntity) -> IMessageCellModel
    
    func loadData()
    
    func add(message content: String)
}

protocol IMessageModelDelegate: class {
    func dataLoaded()
}

class MessagesModel: IMessagesModel {
    
    private let messagesService: IMessageService
    
    private let firestoreUser: IFirestoreUser

    lazy var channel: ChannelEntity = self.messagesService.channel
    
    lazy var frc: NSFetchedResultsController<MessageEntity> = self.messagesService.frc
    
    lazy var userName: String = self.firestoreUser.name()

    weak var delegate: IMessageModelDelegate?
    
    init(messagesService: IMessageService, firestoreUser: IFirestoreUser) {
        self.messagesService = messagesService
        self.firestoreUser = firestoreUser
    }
    
    func cellModel(for message: MessageEntity) -> IMessageCellModel {
        return MessageCellModel(from: message, me: firestoreUser.uuid)
    }
    
    func loadData() {
        do {
            try messagesService.frc.performFetch()
            messagesService.fetchRemote()
            delegate?.dataLoaded()
        } catch { fatalError("messages frc fetch") }
    }
    
    func add(message content: String) {
        messagesService.add(message: content)
    }
    
}

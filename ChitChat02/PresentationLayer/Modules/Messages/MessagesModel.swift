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
    
    func loadData()
    
    func add(message content: String)
}

protocol IMessageModelDelegate {
    func dataLoaded()
}

class MessagesModel: IMessagesModel {
    
    private let messagesService: IMessageService

    lazy var channel: ChannelEntity = self.messagesService.channel
    
    lazy var frc: NSFetchedResultsController<MessageEntity> = self.messagesService.frc

    var delegate: IMessageModelDelegate?
    
    init(messagesService: IMessageService) {
        self.messagesService = messagesService
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

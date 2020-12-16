//
//  ChannelModel.swift
//  ChitChat02
//
//  Created by Timun on 08.11.2020.
//  Copyright © 2020 TimunInc. All rights reserved.
//

import Foundation
import UIKit
import CoreData

protocol IChannelModel {
    
    var frcDelegate: NSFetchedResultsControllerDelegate? { get set }
    
    var delegate: IChannelModelDelegate? { get set }
    
    var frc: NSFetchedResultsController<ChannelEntity> { get }
    
    func performSetup()

    func loadData()

    func cellModel(for channel: ChannelEntity) -> IChannelCellModel
    
    func addChannel(name: String)

    func deleteChannel(_ channel: ChannelEntity)
}

protocol IChannelModelDelegate: class {
    func dataLoaded()
}

class ChannelModel: IChannelModel {

    private let channelService: IChannelService
    
    lazy var frc: NSFetchedResultsController<ChannelEntity> = self.channelService.frc
    
    weak var frcDelegate: NSFetchedResultsControllerDelegate?
    
    weak var delegate: IChannelModelDelegate?
    
    init(channelService: IChannelService) {
        self.channelService = channelService
    }
    
    func performSetup() {
        channelService.setup { [weak self] in
            guard let self = self else { return }
            Log.arch("performSetup")
            self.loadData()
        }
    }

    func loadData() {
        do {
//            channelService.frc.delegate = self.frcDelegate
            try channelService.frc.performFetch()
            channelService.fetchRemote()
            delegate?.dataLoaded()
        } catch { fatalError("channel frc fetch") }
    }
    
    func cellModel(for channel: ChannelEntity) -> IChannelCellModel {
        return ChannelCellModel(from: channel)
    }
    
    func addChannel(name: String) {
        channelService.addChannel(name)
    }
    
    func deleteChannel(_ channel: ChannelEntity) {
        channelService.deleteChannel(channel.identifier)
    }
}

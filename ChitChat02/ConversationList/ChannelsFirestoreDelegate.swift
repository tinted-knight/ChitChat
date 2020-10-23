//
//  ChannelsFirestoreDelegate.swift
//  ChitChat02
//
//  Created by Timun on 17.10.2020.
//  Copyright © 2020 TimunInc. All rights reserved.
//

import Foundation
import Firebase

extension ConversationListViewController {
    func loadChannelList() {
        channelsManager.loadChannelList(onData: { [weak self] (values) in
            guard let self = self else { return }

            if !values.isEmpty {
                self.channels = values
            } else {
                self.showEmpty()
                return
            }
            self.channelsTableView.reloadData()
            self.showLoaded()
        }, onError: { [weak self] error in
            self?.showAlert(title: "Channel load error", message: error)
            self?.showError(error)
        })
    }
    
    @objc func inputNewChannelName() {
        inputAlert(title: "New channel", message: "Input channel name") { [weak self] (text) in
            if !text.isEmpty {
                self?.channelsManager.addChannel(name: text)
            }
        }
    }
}
// MARK: States loading, loaded, error, empty
extension ConversationListViewController {
    func showLoading() {
        channelsTableView.isHidden = true
        emptyLabel.isHidden = true
        loadingIndicator.startAnimating()
    }
    
    func showError(_ text: String) {
        channelsTableView.isHidden = true
        emptyLabel.text = text
        emptyLabel.isHidden = false
        loadingIndicator.stopAnimating()
    }
    
    func showLoaded() {
        channelsTableView.isHidden = false
        emptyLabel.isHidden = true
        loadingIndicator.stopAnimating()
        processCoreData()
    }
    
    func processCoreData() {
        coreDataManager.checkSavedData { [weak self] (chatList) in
            Log.oldschool("checkSavedData")
            if !chatList.isEmpty {
                Log.oldschool("not empty")
                chatList.keys.forEach { (channel) in
                    Log.oldschool("Channel: \(channel.name)")
                    chatList[channel]?.forEach({ (message) in
                        Log.oldschool("     \(message.content)")
                    })
                }
            } else {
                Log.oldschool("empty")
                self?.coreDataManager.loadFromNetAndSaveLocally()
            }
        }
    }
    
    func showEmpty() {
        channelsTableView.isHidden = true
        emptyLabel.text = "empty"
        emptyLabel.isHidden = false
        loadingIndicator.stopAnimating()
    }
}

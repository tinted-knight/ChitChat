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
//        channelsManager.loadChannelList(onData: { [weak self] (values) in
//            guard let self = self else { return }
//
//            if !values.isEmpty {
//            } else {
//                self.showEmpty()
//                return
//            }
//            self.showLoaded()
//        }, onError: { [weak self] error in
//            self?.showAlert(title: "Channel load error", message: error)
//            self?.showError(error)
//        })
    }
    
    @objc func inputNewChannelName() {
        inputAlert(title: "New channel", message: "Input channel name") { [weak self] (text) in
            if !text.isEmpty {
                self?.channelsManager?.addChannel(name: text)
//                self?.channelsManager.addChannel(name: text) { [weak self] result in
//                    if result {
//                        self?.coreDataManager.refreshChannels()
//                    }
//                }
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
//        processCoreData()
    }
    
    func showEmpty() {
        channelsTableView.isHidden = true
        emptyLabel.text = "empty"
        emptyLabel.isHidden = false
        loadingIndicator.stopAnimating()
    }
}

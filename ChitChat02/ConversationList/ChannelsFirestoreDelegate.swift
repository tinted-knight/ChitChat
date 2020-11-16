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
    @objc func inputNewChannelName() {
        inputAlert(title: "New channel", message: "Input channel name") { [weak self] (text) in
            if !text.isEmpty {
                self?.channelsManager?.addChannel(name: text)
            }
        }
    }
}
// MARK: - View states
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
    }
    
    func showEmpty() {
        channelsTableView.isHidden = true
        emptyLabel.text = "empty"
        emptyLabel.isHidden = false
        loadingIndicator.stopAnimating()
    }
}

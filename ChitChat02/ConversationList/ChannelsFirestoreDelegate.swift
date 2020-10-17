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
        channelsManager.loadChannelList { [weak self] (values) in
            guard let self = self else { return }

            if !values.isEmpty {
                self.channels = values
            } else {
                self.emptyLabel.isHidden = false
            }
            self.chatTableView.reloadData()
            self.loadingIndicator.stopAnimating()
        }
    }
    
    @objc func inputNewChannelName() {
        let alert = UIAlertController(title: "New channel", message: "Input channel name", preferredStyle: .alert)

        alert.addTextField { (textField) in
            textField.text = "new channel"
        }

        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { [weak self] (_) in
            guard let textField = alert.textFields?[0], let text = textField.text else { return }
            if !text.isEmpty {
                self?.channelsManager.addChannel(name: text)
            }
        }))

        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: { (_) in
            Log.fire("new channel canceled")
        }))
        
        present(alert, animated: true, completion: nil)
    }
}

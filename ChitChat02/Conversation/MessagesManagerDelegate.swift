//
//  MessagesManagerDelegate.swift
//  ChitChat02
//
//  Created by Timun on 17.10.2020.
//  Copyright © 2020 TimunInc. All rights reserved.
//

import Foundation
import UIKit

extension ConversationViewController {
    func loadData() {
        guard let channel = channel else { return }
        
        messageManager = FirestoreMessageManager(for: channel)
        messageManager?.loadMessageList { [weak self] (values) in
            guard let self = self else { return }
            
            if !values.isEmpty {
                self.messages = values
                    .sorted { (prev, next) in
                        prev.created > next.created
                    }
                    .map { (message) in
                        let senderId = message.senderId
                        let direction: MessageDirection = senderId == "42" ? .outcome : .income

                        return MessageCellModel(
                            text: message.content,
                            date: message.created,
                            sender: senderId,
                            direction: direction)
                }
            } else {
                self.emptyLabel.isHidden = false
            }
            self.loadingIndicator.stopAnimating()
            self.messagesTableView.reloadData()
        }
    }

    @objc func inputNewMessage() {
        let alert = UIAlertController(title: "New message", message: "Input text", preferredStyle: .alert)

        alert.addTextField { (textField) in
            textField.text = ""
        }

        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { [weak self] (_) in
            guard let textField = alert.textFields?[0], let text = textField.text else { return }
            if !text.isEmpty {
                Log.fire("new message: \(text)")
            }
        }))

        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: { (_) in
            Log.fire("new message canceled")
        }))
        
        present(alert, animated: true, completion: nil)
    }
}

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
        messageManager?.loadMessageList(onData: { [weak self] (values) in
            guard let self = self else { return }
            
            if !values.isEmpty {
                self.messages = values.sorted { (prev, next) in
                        prev.created > next.created
                }
                .map { (message) in
                    let senderName = message.senderName
                    let direction: MessageDirection =
                        message.senderId == mySenderId
                            ? .outcome
                            : .income
                    
                    return MessageCellModel(
                        text: message.content,
                        date: message.created,
                        sender: senderName,
                        direction: direction)
                }
            } else {
                self.showEmpty()
                return
            }
            self.messagesTableView.reloadData()
            self.showLoaded()
            }, onError: { [weak self] (message) in
                self?.showAlert(message)
                self?.showError(message)
        })
    }

    @objc func inputNewMessage() {
        let alert = UIAlertController(title: "New message", message: "Input text", preferredStyle: .alert)

        alert.addTextField { (textField) in
            textField.text = ""
        }

        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { [weak self] (_) in
            guard let textField = alert.textFields?[0], let text = textField.text else { return }
            if !text.isEmpty {
                self?.messageManager?.add(message: text)
            }
        }))

        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: { (_) in
            Log.fire("new message canceled")
        }))
        
        present(alert, animated: true, completion: nil)
    }
}

extension ConversationViewController {
    func showLoading() {
        messagesTableView.isHidden = true
        emptyLabel.isHidden = true
        loadingIndicator.startAnimating()
    }
    
    func showError(_ text: String) {
        messagesTableView.isHidden = true
        emptyLabel.text = text
        emptyLabel.isHidden = false
        loadingIndicator.stopAnimating()
    }

    func showLoaded() {
        messagesTableView.isHidden = false
        emptyLabel.isHidden = true
        loadingIndicator.stopAnimating()
    }
    
    func showEmpty() {
        messagesTableView.isHidden = true
        emptyLabel.text = "empty"
        emptyLabel.isHidden = false
        loadingIndicator.stopAnimating()
    }
}

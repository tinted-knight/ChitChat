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
        guard let channel = channel, let myData = myData else { return }
        
        messageManager = FirestoreMessageManager(for: channel, me: myData)
        messageManager?.loadMessageList(onData: { [weak self] (values) in
            guard let self = self else { return }
            
            if !values.isEmpty {
                self.messages = values.sorted { (prev, next) in
                        prev.created > next.created
                }
                .map { (message) in
                    let senderName = message.senderName
                    let direction: MessageDirection =
                        message.senderId == myData.uuid
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
                self?.showAlert(title: "Message loading error", message: message)
                self?.showError(message)
        })
    }

    @objc func inputNewMessage() {
        inputAlert(title: "New message", message: "Input text") { [weak self] (text) in
            if !text.isEmpty {
                self?.messageManager?.add(message: text)
            }
        }
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

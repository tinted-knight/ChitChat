//
//  MessagesManagerDelegate.swift
//  ChitChat02
//
//  Created by Timun on 17.10.2020.
//  Copyright © 2020 TimunInc. All rights reserved.
//

import Foundation
import UIKit
import CoreData

extension ConversationViewController {
//    func loadData() {
//        guard let channel = channel, let myData = myData else { return }
//
//        messageManager = FirestoreMessageManager(for: channel, me: myData)
//        messageManager?.loadMessageList(onData: { [weak self] (values) in
//            guard let self = self else { return }
//
//            if !values.isEmpty {
//                self.messages = values.map { (message) in
//                    let senderName = message.senderName
//                    let direction: MessageDirection =
//                        message.senderId == myData.uuid
//                            ? .outcome
//                            : .income
//
//                    return MessageCellModel(
//                        text: message.content,
//                        date: message.created,
//                        sender: senderName,
//                        direction: direction)
//                }
//            } else {
//                self.showEmpty()
//                return
//            }
//            self.messagesTableView.reloadData()
//            self.showLoaded()
//            }, onError: { [weak self] (message) in
//                self?.showAlert(title: "Message loading error", message: message)
//                self?.showError(message)
//        })
//    }

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

extension ConversationViewController {
    func loadCached() {
        guard let frc = frc else { return }
        do {
//            frc.delegate = nil
            try frc.performFetch()
            Log.oldschool("fetch messages, \(frc.fetchedObjects?.count)")
            showLoaded()
        } catch {
            Log.oldschool(error.localizedDescription)
        }
    }
}

extension ConversationViewController: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    sectionIndexTitleForSectionName sectionName: String) -> String? {
        return sectionName
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        Log.oldschool("willChangeContent")
        messagesTableView.beginUpdates()
    }
 
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange sectionInfo: NSFetchedResultsSectionInfo,
                    atSectionIndex sectionIndex: Int,
                    for type: NSFetchedResultsChangeType) {
        //
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        //
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        Log.oldschool("didChangeContent")
        messagesTableView.endUpdates()
    }
}

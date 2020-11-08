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

extension MessagesViewController {
    @objc func inputNewMessage() {
        inputAlert(title: "New message", message: "Input text") { [weak self] (text) in
            guard let self = self else { return }
            if !text.isEmpty {
                self.messageModel?.add(message: text)
            }
        }
    }
}
// MARK: - View states
extension MessagesViewController {
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

extension MessagesViewController {
    func loadCached() {
//        guard let frc = messageManager?.frc else { return }
//        do {
//            frc.delegate = self
//            try frc.performFetch()
//            messageManager?.fetchRemote { }
//            Log.oldschool("fetch messages, \(frc.fetchedObjects?.count ?? 0)")
//            showLoaded()
//        } catch {
//            Log.oldschool(error.localizedDescription)
//        }
    }
}
// MARK: - FRC
extension MessagesViewController: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    sectionIndexTitleForSectionName sectionName: String) -> String? {
        return sectionName
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        Log.frc("willChangeContent")
        messagesTableView.beginUpdates()
    }
 
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange sectionInfo: NSFetchedResultsSectionInfo,
                    atSectionIndex sectionIndex: Int,
                    for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            messagesTableView.insertSections(NSIndexSet(index: sectionIndex) as IndexSet, with: .automatic)
        case .delete:
            messagesTableView.deleteSections(NSIndexSet(index: sectionIndex) as IndexSet, with: .automatic)
        default:
            return
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let newIndexPath = newIndexPath {
                messagesTableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        case .delete:
            if let indexPath = indexPath {
                messagesTableView.deleteRows(at: [indexPath], with: .automatic)
            }
        case .update:
            if let indexPath = indexPath {
                guard let message = messageModel?.frc.object(at: indexPath) else { break }
                guard let cell = messagesTableView.cellForRow(at: indexPath) as? MessageCell else { break }
                let direction: MessageDirection = message.senderId == myDataModel?.uuid ? .outcome : .income
                cell.configure(with: MessageCellModel(text: message.content,
                                                      date: message.created,
                                                      sender: message.senderName,
                                                      direction: direction))
            }
        case .move:
            if let indexPath = indexPath {
                messagesTableView.deleteRows(at: [indexPath], with: .automatic)
            }
            if let newIndexPath = newIndexPath {
                messagesTableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        default:
            break
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        Log.frc("didChangeContent")
        messagesTableView.endUpdates()
    }
}

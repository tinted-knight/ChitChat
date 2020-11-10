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

// MARK: - UITableViewDataSource
extension MessagesViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let sections = messageModel?.frc.sections else { return 0 }
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let frc = messageModel?.frc, let sections = frc.sections else { return 0 }
        
        return sections[section].numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let model = messageModel, let frc = messageModel?.frc else { return UITableViewCell() }
        guard let theme = themeModel else { return UITableViewCell() }

        let cellModel = model.cellModel(for: frc.object(at: indexPath))
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: cellReuseId(for: cellModel.direction),
            for: indexPath) as? MessageCell else {
                return UITableViewCell()
        }

        cell.contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
        cell.configure(with: cellModel, theme: theme)

        return cell
    }
    
    private func cellReuseId(for direction: MessageDirection) -> String {
        switch direction {
        case .income:
            return incomeCellId
        case .outcome:
            return outcomeCellId
        }
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
                guard let model = messageModel else { break }
                guard let theme = themeModel else { break }
                let cellModel = model.cellModel(for: message)
                cell.configure(with: cellModel, theme: theme)
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

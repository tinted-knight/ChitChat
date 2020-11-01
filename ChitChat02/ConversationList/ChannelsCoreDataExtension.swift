//
//  ChannelsCoreDataExtension.swift
//  ChitChat02
//
//  Created by Timun on 31.10.2020.
//  Copyright © 2020 TimunInc. All rights reserved.
//

import Foundation
import CoreData

extension ConversationListViewController {
    func loadFromCache() {
        Log.oldschool(#function)
        do {
            coreDataManager.frcChannels.delegate = self
            try coreDataManager.frcChannels.performFetch()
            showLoaded()
            coreDataManager.refreshChannels()
//            coreDataManager.loadFromNetAndSaveLocally()
        } catch {
            Log.oldschool(error.localizedDescription)
        }
    }
    
    func reloadData(for channel: ChannelEntity) {
        // refresh specific channel
        coreDataManager.refresh(channel)
        needRefresh = true
    }
    
//    func processCoreData() {
//        coreDataManager.checkSavedData { [weak self] (chatList) in
//            Log.oldschool("checkSavedData: ")
//            if !chatList.isEmpty {
//                Log.oldschool("     NOT empty")
//            } else {
//                Log.oldschool("     empty")
//            }
//            self?.coreDataManager.loadFromNetAndSaveLocally()
//        }
//    }
}

extension ConversationListViewController: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    sectionIndexTitleForSectionName sectionName: String) -> String? {
        return sectionName
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        Log.frc("willChangeContent")
        channelsTableView.beginUpdates()
    }
 
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange sectionInfo: NSFetchedResultsSectionInfo,
                    atSectionIndex sectionIndex: Int,
                    for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            channelsTableView.insertSections(NSIndexSet(index: sectionIndex) as IndexSet, with: .fade)
        case .delete:
            channelsTableView.deleteSections(NSIndexSet(index: sectionIndex) as IndexSet, with: .fade)
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
            Log.frc("insert")
            if let newIndexPath = newIndexPath {
                channelsTableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        case .delete:
            Log.frc("delete")
            if let indexPath = indexPath {
                channelsTableView.deleteRows(at: [indexPath], with: .automatic)
            }
        case .update:
            Log.frc("update")
            if let indexPath = indexPath {
                let channel = coreDataManager.frcChannels.object(at: indexPath)
                guard let cell = channelsTableView.cellForRow(at: indexPath) as? ConversationCell else { break }
                cell.configure(with: channel)
            }
        case .move:
            Log.frc("move")
            if let indexPath = indexPath {
                channelsTableView.deleteRows(at: [indexPath], with: .automatic)
            }
            if let newIndexPath = newIndexPath {
                channelsTableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        default:
            break
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        Log.frc("didChangeContent")
        channelsTableView.endUpdates()
    }
}

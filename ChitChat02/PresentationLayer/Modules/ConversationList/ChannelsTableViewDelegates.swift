//
//  ChannelsCoreDataExtension.swift
//  ChitChat02
//
//  Created by Timun on 31.10.2020.
//  Copyright © 2020 TimunInc. All rights reserved.
//

import Foundation
import UIKit
import CoreData

// MARK: - NSFetchedResultsControllerDelegate
extension ChannelsViewController: NSFetchedResultsControllerDelegate {
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
            if let indexPath = indexPath, let channel = controller.object(at: indexPath) as? ChannelEntity,
                let theme = themeModel {
                guard let cell = channelsTableView.cellForRow(at: indexPath) as? ConversationCell else { break }
                cell.configure(with: channel, theme: theme)
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
// MARK: UITableViewDataSource
extension ChannelsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let channel = channelModel?.frc.object(at: indexPath) else { return UITableViewCell() }
        guard let theme = themeModel else { return UITableViewCell() }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseId, for: indexPath)
            as? ConversationCell else {
                return UITableViewCell()
        }

        cell.configure(with: channel, theme: theme)
        return cell
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        guard let sections = channelModel?.frc.sections else { return 0 }
        return sections.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let sections = channelModel?.frc.sections else { return nil }
        return sections[section].name
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = channelModel?.frc.sections else { return 0 }
        return sections[section].numberOfObjects
    }
}
// MARK: UITableViewDelegate
extension ChannelsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let channel = channelModel?.frc.fetchedObjects?[indexPath.row] else { return }
        Log.oldschool("openConversation for channel \(channel.name), id = \(channel.identifier)")
        guard let messages = presentationAssembly?.messagesViewController(for: channel) else { return }
        navigationController?.pushViewController(messages, animated: true)
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard let channel = channelModel?.frc.fetchedObjects?[indexPath.row] else { return }
        if editingStyle == .delete {
            Log.oldschool("delete row, \(channel.name)")
            channelModel?.deleteChannel(channel)
        }
    }
}

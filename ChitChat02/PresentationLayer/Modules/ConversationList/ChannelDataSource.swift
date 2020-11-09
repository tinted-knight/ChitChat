//
//  DataSource.swift
//  ChitChat02
//
//  Created by Timun on 09.11.2020.
//  Copyright © 2020 TimunInc. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class ChannelDataSource: NSObject, UITableViewDataSource {
    
    private let cellReuseId = "chat-list-cell"
    private let headerReuseId = "header-online-reuse-id"

    private let frc: NSFetchedResultsController<ChannelEntity>
    
    init(frc: NSFetchedResultsController<ChannelEntity>) {
        Log.arch("ChannelDataSource")
        self.frc = frc
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let channel = frc.object(at: indexPath)
        Log.arch("\(#function)")
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseId, for: indexPath)
            as? ConversationCell else {
                return UITableViewCell()
        }

        cell.configure(with: channel)
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let sections = frc.sections else { return 0 }
        Log.arch("\(#function), \(sections.count)")
        return sections.count
    }

//    private func simpleHeader(_ text: String) -> UIView {
//        let view = UILabel()
//        view.text = text
//        return view
//    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let sections = frc.sections else { return nil }
        return sections[section].name
    }

//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: headerReuseId) as? HeaderCell else {
//            return simpleHeader("Channels")
//        }
//        cell.configure(with: "Channels")
//        return cell
//    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = frc.sections else { return 0 }
        Log.arch("\(#function), \(sections[section].numberOfObjects)")
        return sections[section].numberOfObjects
    }
}

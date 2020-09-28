//
//  ConversationListViewController.swift
//  ChitChat02
//
//  Created by Timun on 28.09.2020.
//  Copyright © 2020 TimunInc. All rights reserved.
//

import UIKit

class ConversationListViewController: UIViewController {

    @IBOutlet weak var chatTableView: UITableView!

    private let cellReuseId = "chat-list-cell"
    private let sectionOnlineId = 0
    private let sectionOfflineId = 1
    
    private let fakeOnlineList = [
        ConversationCellModel(
            name: "name1",
            message: "message1",
            date: Date(),
            isOnline: true,
            hasUnreadMessages: true
        ),
        ConversationCellModel(
            name: "name2",
            message: "message2",
            date: Date(),
            isOnline: true,
            hasUnreadMessages: false
        ),
    ]
    
    private let fakeOfflineList = [
        ConversationCellModel(
            name: "name2",
            message: "message2",
            date: Date(),
            isOnline: false,
            hasUnreadMessages: false
        ),
    ]

    private lazy var headerOnline: UIView = {
        let headerOnline = UILabel()
        headerOnline.text = "Online"

        return headerOnline
    }()
    
    private lazy var headerOffline: UIView = {
        let headerOffline = UILabel()
        headerOffline.text = "Offline"

        return headerOffline
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareUi()
    }

    private func prepareUi() {
        title = "Tinkoff Chat"

        chatTableView.register(UINib(nibName: "ConversationCell", bundle: nil), forCellReuseIdentifier: cellReuseId)
        chatTableView.dataSource = self
        chatTableView.delegate = self
    }
}

extension ConversationListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = chatTableView.dequeueReusableCell(withIdentifier: cellReuseId, for: indexPath)
            as? ConversationCell else {
            return UITableViewCell()
        }

        if indexPath.section == sectionOnlineId {
            cell.configure(with: fakeOnlineList[indexPath.row])
        } else {
            cell.configure(with: fakeOfflineList[indexPath.row])
        }
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == sectionOnlineId {
            return headerOnline
        } else {
            return headerOffline
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == sectionOnlineId {
            return fakeOnlineList.count
        } else {
            return fakeOfflineList.count
        }
    }
}

extension ConversationListViewController: UITableViewDelegate {
    
}

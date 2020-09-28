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
    
    private let fakeChatList = [
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
            isOnline: false,
            hasUnreadMessages: false
        ),
    ]
    
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
        cell.configure(with: fakeChatList[indexPath.row])
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fakeChatList.count
    }
}

extension ConversationListViewController: UITableViewDelegate {
    
}

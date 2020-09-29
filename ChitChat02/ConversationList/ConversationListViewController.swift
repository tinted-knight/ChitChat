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

    private let segueConversation = "segue_single_conversation"
    private let cellReuseId = "chat-list-cell"
    private let sectionOnlineId = 0
    private let sectionHystoryId = 1
    
    private lazy var headerOnline: UIView = {
        let headerOnline = UILabel()
        headerOnline.text = "Online"

        return headerOnline
    }()
    
    private lazy var headerOffline: UIView = {
        let headerOffline = UILabel()
        headerOffline.text = "History"

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
// MARK: -UITableViewDataSource
extension ConversationListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = chatTableView.dequeueReusableCell(withIdentifier: cellReuseId, for: indexPath)
            as? ConversationCell else {
            return UITableViewCell()
        }

        cell.configure(with: fakeChatList[indexPath.section][indexPath.row])
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
        return fakeChatList[section].count
    }
}
// MARK: -UITableViewDelegate
extension ConversationListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let contactName = fakeChatList[indexPath.section][indexPath.row].name
        performSegue(withIdentifier: segueConversation, sender: contactName)
    }
}
// MARK: -Navigation helpers
extension ConversationListViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? ConversationViewController,
            let name = sender as? String {
            controller.contactName = name
        }
    }
}

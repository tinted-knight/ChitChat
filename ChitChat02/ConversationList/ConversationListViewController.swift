//
//  ConversationListViewController.swift
//  ChitChat02
//
//  Created by Timun on 28.09.2020.
//  Copyright © 2020 TimunInc. All rights reserved.
//

import UIKit

private enum TableSections: Int {
    case online = 0
    case history = 1
}

class ConversationListViewController: UIViewController {
    
    @IBOutlet weak var chatTableView: UITableView!
    
    private let segueConversation = "segue_single_conversation"
    private let segueProfile = "segue_show_profile"
    
    private let cellReuseId = "chat-list-cell"
    private let headerReuseId = "header-online-reuse-id"
    
    private let sectionOnlineId = 0
    private let sectionHistoryId = 1
    
    private lazy var simpleSectionHeader: UIView = UILabel()
    
    private let onlineString = "Online"
    private let historyString = "History"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareUi()
    }
    
    private func prepareUi() {
        title = "Tinkoff Chat"
        
        chatTableView.register(UINib(nibName: "ConversationCell", bundle: nil), forCellReuseIdentifier: cellReuseId)
        chatTableView.register(UINib(nibName: "HeaderCell", bundle: nil), forCellReuseIdentifier: headerReuseId)
        
        chatTableView.dataSource = self
        chatTableView.delegate = self
        
        let profilePicture = UIImage(named: "ProfileIcon")?.withRenderingMode(.alwaysOriginal)
        let profileNavItem = UIBarButtonItem(
            image: profilePicture,
            style: .plain,
            target: self,
            action: #selector(profileOnTap)
        )
        navigationItem.rightBarButtonItem = profileNavItem
    }
    
    @objc private func profileOnTap() {
        performSegue(withIdentifier: segueProfile, sender: nil)
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
    
    private func simpleHeader(_ text: String) -> UIView {
        let view = UILabel()
        view.text = text
        return view
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch TableSections.init(rawValue: section) {
            case .online:
                return buildSectionHeader(tableView, with: onlineString)
            case .history:
                return buildSectionHeader(tableView, with: historyString)
            case .none:
                return UIView()
        }
    }
    
    private func buildSectionHeader(_ tableView: UITableView, with text: String) -> UIView {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: headerReuseId) as? HeaderCell else {
            return simpleHeader(text)
        }
        cell.configure(with: text)
        return cell
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

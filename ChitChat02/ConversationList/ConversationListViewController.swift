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
    
    private var onlineData: [ConversationCellModel] = []
    private var historyData: [ConversationCellModel] = []
    
    private var currentTheme: Theme = .green
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ThemeManager.apply(theme: currentTheme)
        
        prepareUi()
        prepareData(with: fakeChatList)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        view.backgroundColor = ThemeManager.get().backgroundColor
    }
    
    private func prepareUi() {
        title = "Tinkoff Chat"
        
        chatTableView.register(UINib(nibName: "ConversationCell", bundle: nil), forCellReuseIdentifier: cellReuseId)
        chatTableView.register(UINib(nibName: "HeaderCell", bundle: nil), forCellReuseIdentifier: headerReuseId)
        
        chatTableView.dataSource = self
        chatTableView.delegate = self
        
        setupNavBarButtons()
        setupNavBarTheme()
    }
    
    private func setupNavBarButtons() {
        let profilePicture = UIImage(named: "ProfileIcon")?.withRenderingMode(.alwaysOriginal)
        let profileNavItem = UIBarButtonItem(
            image: profilePicture,
            style: .plain,
            target: self,
            action: #selector(profileOnTap)
        )
        navigationItem.rightBarButtonItem = profileNavItem
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(named: "Gear"),
            style: .plain,
            target: self,
            action: #selector(settingsOnTap))
    }
    
    private func prepareData(with values: [[ConversationCellModel]]) {
        onlineData = values[0]
        historyData = values[1].filter {!$0.message.isEmpty}
    }
    
    @objc private func profileOnTap() {
        performSegue(withIdentifier: segueProfile, sender: nil)
    }
    
    @objc private func settingsOnTap() {
        if let themesViewController = ThemesViewController.instance() {
            themesViewController.selectedTheme = currentTheme
            navigationController?.pushViewController(themesViewController, animated: true)
            //            themesViewController.delegate = self
            themesViewController.themePicked = { [weak self] value in
                //                applog("from closure : \(value)")
                self?.currentTheme = value
                ThemeManager.apply(theme: value)
                self?.chatTableView.reloadData()
                self?.setupNavBarTheme()
            }
        }
    }
    
    private func setupNavBarTheme() {
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: ThemeManager.get().textColor]
        navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: ThemeManager.get().textColor]
        navigationController?.navigationBar.tintColor = ThemeManager.get().tintColor
        switch ThemeManager.get().brightness {
            case .dark:
                navigationController?.navigationBar.barStyle = .black
            case .light:
                navigationController?.navigationBar.barStyle = .default
        }
    }
}

extension ConversationListViewController: ThemesPickerDelegate {
    func theme(picked value: Theme) {
        applog("from delegate : \(value)")
    }
}

// MARK: -UITableViewDataSource
extension ConversationListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseId, for: indexPath)
            as? ConversationCell else {
                return UITableViewCell()
        }
        
        switch TableSections.init(rawValue: indexPath.section) {
            case .online:
                cell.configure(with: onlineData[indexPath.row])
            case .history:
                cell.configure(with: historyData[indexPath.row])
            default:
                return UITableViewCell()
        }
        
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
        switch TableSections.init(rawValue: section) {
            case .online:
                return onlineData.count
            case .history:
                return historyData.count
            default:
                return 0
        }
    }
}
// MARK: -UITableViewDelegate
extension ConversationListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch TableSections.init(rawValue: indexPath.section) {
            case .online:
                openConversation(with: onlineData[indexPath.row].name)
            case .history:
                openConversation(with: historyData[indexPath.row].name)
            default:
                applog("Something has gone wrong")
        }
    }
    
    private func openConversation(with contactName: String) {
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

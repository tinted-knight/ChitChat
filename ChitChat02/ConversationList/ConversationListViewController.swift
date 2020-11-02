//
//  ConversationListViewController.swift
//  ChitChat02
//
//  Created by Timun on 28.09.2020.
//  Copyright © 2020 TimunInc. All rights reserved.
//

import UIKit

class ConversationListViewController: UIViewController {
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var channelsTableView: UITableView!
    @IBOutlet weak var emptyLabel: UILabel!
    
    private let cellReuseId = "chat-list-cell"
    private let headerReuseId = "header-online-reuse-id"
    
    private lazy var simpleSectionHeader: UIView = UILabel()

    var currentTheme: Theme = .black
    let themeDataManager = ThemeDataManager()
    
    var myData: UserData?
    
    var channelsManager: ChannelManager?
    let newSchool = NewSchoolCoreData()
    
    var needRefresh = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentTheme = loadAppTheme()
        myData = loadUserData()
        
        prepareUi()
        newSchool.createContainer { [weak self] (container) in
            self?.channelsManager = SmartChannelManager(container)
            self?.loadFromCache()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        view.backgroundColor = ThemeManager.get().backgroundColor
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        Log.oldschool("\(#function), needRefresh = \(needRefresh)")
        super.viewDidAppear(animated)
    }
    
    private func loadUserData() -> UserData? {
        let prefs = UserDefaults.standard
        guard let uuid = prefs.string(forKey: UserData.keyUUID) as String? else { return nil }
        
        return UserData(uuid: uuid)
    }
}
// MARK: UI Setup
extension ConversationListViewController {
    private func prepareUi() {
        loadingIndicator.hidesWhenStopped = true
        showLoading()

        emptyLabel.isHidden = true
        emptyLabel.text = "Looks like there are no messages in this channel"

        title = "Tinkoff Chat"
        
        channelsTableView.register(UINib(nibName: "ConversationCell", bundle: nil), forCellReuseIdentifier: cellReuseId)
        channelsTableView.register(UINib(nibName: "HeaderCell", bundle: nil), forCellReuseIdentifier: headerReuseId)
        
        channelsTableView.dataSource = self
        channelsTableView.delegate = self
        
        setupNavBarButtons()
        applyTheme(currentTheme)
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
        
        navigationItem.rightBarButtonItems?.append(UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(inputNewChannelName)))
    }
}
// MARK: UI Actions
extension ConversationListViewController {
    @objc private func profileOnTap() {
        openProfileScreen()
    }
    
    @objc private func settingsOnTap() {
        openSettingsScreen { [weak self] value, saveChoice in
            if saveChoice {
                applog("closure: yay! new theme")
                self?.applyTheme(value)
                self?.saveCurrentTheme()
            } else {
                applog("closure: no new theme")
                // need to call to fix navbar text color
                self?.updateNavbarAppearence()
            }
        }
    }
}
// MARK: UITableViewDataSource
extension ConversationListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let channel = channelsManager?.frc.object(at: indexPath) else { return UITableViewCell() }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseId, for: indexPath)
            as? ConversationCell else {
                return UITableViewCell()
        }

        cell.configure(with: channel)
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let sections = channelsManager?.frc.sections else { return 0 }
        return sections.count
    }

    private func simpleHeader(_ text: String) -> UIView {
        let view = UILabel()
        view.text = text
        return view
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let sections = channelsManager?.frc.sections else { return nil }
        return sections[section].name
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: headerReuseId) as? HeaderCell else {
            return simpleHeader("Channels")
        }
        cell.configure(with: "Channels")
        return cell
    }

    private func buildSectionHeader(_ tableView: UITableView, with text: String) -> UIView {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: headerReuseId) as? HeaderCell else {
            return simpleHeader("Channels")
        }
        cell.configure(with: "Channels")
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = channelsManager?.frc.sections else { return 0 }
        return sections[section].numberOfObjects
    }
}
// MARK: UITableViewDelegate
extension ConversationListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Log.oldschool("table row select")
        guard let channel = channelsManager?.frc.fetchedObjects?[indexPath.row] else { return }
        guard let container = newSchool.container else { return }
        guard let userData = myData else { return }
        Log.oldschool("openConversation for \(channel.identifier), \(channel.name)")
        openConversationScreen(for: channel,
                               with: SmartMessageManager(for: channel,
                                                         me: userData,
                                                         container: container))
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard let channel = channelsManager?.frc.fetchedObjects?[indexPath.row] else { return }
        if editingStyle == .delete {
            Log.oldschool("delete row, \(channel.name)")
            channelsManager?.deleteChannel(channel)
        }
    }
}

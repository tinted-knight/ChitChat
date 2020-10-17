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
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var chatTableView: UITableView!
    @IBOutlet weak var emptyLabel: UILabel!
    
    private let segueConversation = "segue_single_conversation"
    private let segueProfile = "segue_show_profile"
    
    private let cellReuseId = "chat-list-cell"
    private let headerReuseId = "header-online-reuse-id"
    
    private let sectionOnlineId = 0
    private let sectionHistoryId = 1
    
    private lazy var simpleSectionHeader: UIView = UILabel()

    var channels: [Channel] = []
    
    private var currentTheme: Theme = .black
    private let themeDataManager = ThemeDataManager()
    
    // под идее, конечно, firestore инициаизируется не здесь
    private let firestore = FirestoreDataManager()

    var channelsManager: ChannelsManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentTheme = loadAppTheme()
        
        prepareUi()
        
        setupFirestore()
        loadChannelList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        view.backgroundColor = ThemeManager.get().backgroundColor
        super.viewWillAppear(animated)
    }
    
    private func prepareUi() {
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.startAnimating()

        emptyLabel.isHidden = true
        emptyLabel.text = "Looks like there are no messages in this channel"

        title = "Tinkoff Chat"
        
        chatTableView.register(UINib(nibName: "ConversationCell", bundle: nil), forCellReuseIdentifier: cellReuseId)
        chatTableView.register(UINib(nibName: "HeaderCell", bundle: nil), forCellReuseIdentifier: headerReuseId)
        
        chatTableView.dataSource = self
        chatTableView.delegate = self
        
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
    }
    
    private func setupFirestore() {
        channelsManager = firestore
    }
}
// MARK: ThemesPickerDelegate and stuff
extension ConversationListViewController: ThemesPickerDelegate {
    func theme(picked value: Theme) {
        //
    }

    func result(_ value: Theme, _ saveChoice: Bool) {
        if saveChoice {
            applyTheme(value)
            saveCurrentTheme()
        } else {
            //
        }
    }
    
    private func applyTheme(_ value: Theme) {
        currentTheme = value
        chatTableView.reloadData()
        
        ThemeManager.apply(theme: value)
        
        updateNavbarAppearence()
        navigationController?.navigationBar.tintColor = ThemeManager.get().tintColor
        // inspite of setting NavBarStyle in ThemeManager need to duplicate here
        switch ThemeManager.get().brightness {
        case .dark:
            navigationController?.navigationBar.barStyle = .black
        case .light:
            navigationController?.navigationBar.barStyle = .default
        }
    }
    
    private func updateNavbarAppearence() {
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: ThemeManager.get().textColor]
        navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: ThemeManager.get().textColor]
    }
    
    private func saveCurrentTheme() {
        applog(#function)
        let pref = UserDefaults.standard
        pref.set(currentTheme.rawValue, forKey: ThemeManager.key)
        themeDataManager.save(ThemeManager.get())
    }
    
    private func loadAppTheme() -> Theme {
        let prefs = UserDefaults.standard
        return Theme(rawValue: prefs.integer(forKey: ThemeManager.key)) ?? Theme.classic
    }
}
// MARK: UI Actions
extension ConversationListViewController {
    @objc private func profileOnTap() {
        performSegue(withIdentifier: segueProfile, sender: nil)
    }
    
    @objc private func settingsOnTap() {
        if let themesViewController = ThemesViewController.instance() {
            themesViewController.activeTheme = currentTheme
            
//            themesViewController.delegate = self
            
            themesViewController.themePicked = { value in
                //
            }
            
            themesViewController.result = { [weak self] value, saveChoice in
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
            
            navigationController?.pushViewController(themesViewController, animated: true)
        }
    }
}
// MARK: UITableViewDataSource
extension ConversationListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseId, for: indexPath)
            as? ConversationCell else {
                return UITableViewCell()
        }
        
        cell.configure(with: channels[indexPath.row])
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    private func simpleHeader(_ text: String) -> UIView {
        let view = UILabel()
        view.text = text
        return view
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
        return channels.count
    }
}
// MARK: UITableViewDelegate
extension ConversationListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        openConversation(for: channels[indexPath.row], via: firestore)
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    private func openConversation(for channel: Channel, via dataManager: MessagesManager) {
        if let viewController = ConversationViewController.instance() {
            viewController.channel = channel
            viewController.dataManager = dataManager
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
}
// MARK: Navigation helpers
extension ConversationListViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? ConversationViewController,
            let channel = sender as? Channel {
            controller.channel = channel
        }
    }
}

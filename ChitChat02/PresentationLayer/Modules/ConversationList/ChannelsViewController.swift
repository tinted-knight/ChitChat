//
//  ConversationListViewController.swift
//  ChitChat02
//
//  Created by Timun on 28.09.2020.
//  Copyright © 2020 TimunInc. All rights reserved.
//

import UIKit

class ChannelsViewController: UIViewController {

    static func instance() -> ChannelsViewController? {
        let storyboard = UIStoryboard(name: "ChannelsViewController", bundle: nil)
        return storyboard.instantiateInitialViewController() as? ChannelsViewController
    }
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var channelsTableView: UITableView!
    @IBOutlet weak var emptyLabel: UILabel!
    
    let cellReuseId = "chat-list-cell"
    let headerReuseId = "header-online-reuse-id"
    
    var themeModel: IThemeModelNew?
    
    var myDataModel: IUserDataModel?
    
    var channelModel: IChannelModel?

    var presentationAssembly: PresentationAssembly?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        prepareUi()

        channelModel?.delegate = self
        channelModel?.performSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        view.backgroundColor = ThemeManager.get().backgroundColor
        super.viewWillAppear(animated)
    }
    
}
// MARK: - IChannelModelDelegate
extension ChannelsViewController: IChannelModelDelegate {
    func dataLoaded(_ dataSource: UITableViewDataSource) {
        channelModel?.frc.delegate = self
        channelsTableView.dataSource = self
        channelsTableView.delegate = self
        showLoaded()
    }
}

// MARK: UI Setup
extension ChannelsViewController {
    private func prepareUi() {
        loadingIndicator.hidesWhenStopped = true
        showLoading()

        emptyLabel.isHidden = true
        emptyLabel.text = "Looks like there are no messages in this channel"

        title = "Tinkoff Chat"
        
        channelsTableView.register(UINib(nibName: "ConversationCell", bundle: nil), forCellReuseIdentifier: cellReuseId)
        channelsTableView.register(UINib(nibName: "HeaderCell", bundle: nil), forCellReuseIdentifier: headerReuseId)
        
        setupNavBarButtons()
        if let theme = themeModel?.currentTheme {
            applyTheme(theme)
        }
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
extension ChannelsViewController {
    @objc private func profileOnTap() {
        guard let controller = presentationAssembly?.profileViewController() else { return }
        navigationController?.present(controller, animated: true, completion: nil)
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

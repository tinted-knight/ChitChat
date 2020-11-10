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
    
    var themeModel: IThemeModel
    
    let myDataModel: IFirestoreUser
    
    var channelModel: IChannelModel

    let presentationAssembly: PresentationAssembly
    
    init(presentationAssembly: PresentationAssembly, channelModel: IChannelModel,
         myDataModel: IFirestoreUser, themeModel: IThemeModel,
         nibName: String, bundle: Bundle?) {
        
        self.presentationAssembly = presentationAssembly
        self.channelModel = channelModel
        self.myDataModel = myDataModel
        self.themeModel = themeModel
        
        super.init(nibName: nibName, bundle: bundle)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        prepareUi()

        channelModel.delegate = self
        channelModel.performSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        view.backgroundColor = themeModel.getThemeData().backgroundColor
        super.viewWillAppear(animated)
    }
    
}
// MARK: - IChannelModelDelegate
extension ChannelsViewController: IChannelModelDelegate {
    func dataLoaded() {
        channelModel.frc.delegate = self
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
        
        channelsTableView.register(UINib(nibName: "ChannelCell", bundle: nil), forCellReuseIdentifier: cellReuseId)
        
        setupNavBarButtons()

        themeModel.delegate = self
        themeModel.applyCurrent()
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
        let controller = presentationAssembly.profileViewController()
        navigationController?.present(controller, animated: true, completion: nil)
    }
    
    @objc private func settingsOnTap() {
        let controller = presentationAssembly.themesViewController()
        navigationController?.pushViewController(controller, animated: true)
    }
}

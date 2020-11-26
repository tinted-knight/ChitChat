//
//  ConversationListViewController.swift
//  ChitChat02
//
//  Created by Timun on 28.09.2020.
//  Copyright © 2020 TimunInc. All rights reserved.
//

import UIKit

class ChannelsViewController: UIViewController {

    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var channelsTableView: UITableView!
    
    var themeModel: IThemeModel
    
    let myDataModel: IFirestoreUser
    
    var channelModel: IChannelModel

    let presentationAssembly: PresentationAssembly
    
    init(presentationAssembly: PresentationAssembly, channelModel: IChannelModel,
         myDataModel: IFirestoreUser, themeModel: IThemeModel, nibName: String, bundle: Bundle?) {
        
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

        title = "Tinkoff Chat"
        
        channelsTableView.register(UINib(nibName: ChannelCellModel.nibName, bundle: nil),
                                   forCellReuseIdentifier: ChannelCellModel.cellReuseId)
        
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
// MARK: InputDialog
extension ChannelsViewController {
    @objc func inputNewChannelName() {
        inputAlert(title: "New channel", message: "Input channel name") { [weak self] (text) in
            if !text.isEmpty {
                self?.channelModel.addChannel(name: text)
            }
        }
    }
}

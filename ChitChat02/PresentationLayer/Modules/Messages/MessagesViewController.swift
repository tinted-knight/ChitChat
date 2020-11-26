//
//  ConversationViewController.swift
//  ChitChat02
//
//  Created by Timun on 28.09.2020.
//  Copyright © 2020 TimunInc. All rights reserved.
//

import UIKit
import CoreData

class MessagesViewController: UIViewController {

    static func instance() -> MessagesViewController? {
        let storyboard = UIStoryboard(name: "MessagesViewController", bundle: nil)
        return storyboard.instantiateInitialViewController() as? MessagesViewController
    }
    
    var messageModel: IMessagesModel?
    
    var themeModel: IThemeModel?

    @IBOutlet weak var messagesTableView: UITableView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        prepareUi()
        messageModel?.delegate = self
        messageModel?.frc.delegate = self
        messageModel?.loadData()
        applyTheme()
    }
    
    private func prepareUi() {
        loadingIndicator.hidesWhenStopped = true
        showLoading()
        
        title = messageModel?.channel.name ?? ""
        
        messagesTableView.register(UINib(nibName: MessageCellModel.IncomeNib, bundle: nil),
                                   forCellReuseIdentifier: MessageCellModel.IncomeCellId)
        messagesTableView.register(UINib(nibName: MessageCellModel.OutcomeNib, bundle: nil),
                                   forCellReuseIdentifier: MessageCellModel.OutcomeCellId)

        messagesTableView.dataSource = self
        messagesTableView.transform = CGAffineTransform(scaleX: 1, y: -1)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self, action: #selector(inputNewMessage))
    }
    
    private func applyTheme() {
        view.backgroundColor = themeModel?.getThemeData().backgroundColor
    }

    @objc func inputNewMessage() {
        inputAlert(title: "New message", message: "Input text") { [weak self] (text) in
            guard let self = self else { return }
            if !text.isEmpty {
                self.messageModel?.add(message: text)
            }
        }
    }
}

extension MessagesViewController: IMessageModelDelegate {
    func dataLoaded() {
        messagesTableView.isHidden = false
        loadingIndicator.stopAnimating()
    }

    func showLoading() {
        messagesTableView.isHidden = true
        loadingIndicator.startAnimating()
    }
}

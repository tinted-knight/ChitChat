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
        let storyboard = UIStoryboard(name: "ConversationViewController", bundle: nil)
        return storyboard.instantiateInitialViewController() as? MessagesViewController
    }
    
    var messageModel: IMessagesModel?
    
    var themeModel: IThemeModelNew?

    var messages: [MessageCellModel] = []
    
    let incomeCellId = "income-cell-id"
    let outcomeCellId = "outcome-cell-id"

    @IBOutlet weak var messagesTableView: UITableView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var emptyLabel: UILabel!
    
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
        
        emptyLabel.isHidden = true
        emptyLabel.text = "Looks like there are no messages in this channel"
        
        title = messageModel?.channel.name ?? ""
        
        messagesTableView.register(UINib(nibName: "IncomeMessageCell", bundle: nil), forCellReuseIdentifier: incomeCellId)
        messagesTableView.register(UINib(nibName: "OutcomeMessageCell", bundle: nil), forCellReuseIdentifier: outcomeCellId)

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
        emptyLabel.isHidden = true
        loadingIndicator.stopAnimating()
    }

    func showLoading() {
        messagesTableView.isHidden = true
        emptyLabel.isHidden = true
        loadingIndicator.startAnimating()
    }
}

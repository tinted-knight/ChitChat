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
    
//    var messageManager: IMessageService?
    var messageModel: IMessagesModel?

//    var myData: UserData?
    var myDataModel: IUserDataModel?
    
    var messages: [MessageCellModel] = []
    
    private let nonameContact = "Noname"
    
    private let incomeCellId = "income-cell-id"
    private let outcomeCellId = "outcome-cell-id"

    @IBOutlet weak var messagesTableView: UITableView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var emptyLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        prepareUi()
        messageModel?.delegate = self
        messageModel?.frc.delegate = self
        messageModel?.loadData()
//        loadCached()
        applyTheme()
    }
    
    private func prepareUi() {
        loadingIndicator.hidesWhenStopped = true
        showLoading()
        
        emptyLabel.isHidden = true
        emptyLabel.text = "Looks like there are no messages in this channel"
        
        title = messageModel?.channel.name ?? nonameContact
        
        messagesTableView.register(UINib(nibName: "IncomeMessageCell", bundle: nil), forCellReuseIdentifier: incomeCellId)
        messagesTableView.register(UINib(nibName: "OutcomeMessageCell", bundle: nil), forCellReuseIdentifier: outcomeCellId)
        messagesTableView.delegate = self
        messagesTableView.dataSource = self
        messagesTableView.transform = CGAffineTransform(scaleX: 1, y: -1)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self, action: #selector(inputNewMessage))
    }
    
    private func applyTheme() {
        view.backgroundColor = ThemeManager.get().backgroundColor
    }
}

extension MessagesViewController: IMessageModelDelegate {
    func dataLoaded() {
        showLoaded()
    }
}

// MARK: - UITableViewDelegate
extension MessagesViewController: UITableViewDelegate {
    
}
// MARK: - UITableViewDataSource
extension MessagesViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let sections = messageModel?.frc.sections else { return 0 }
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let frc = messageModel?.frc, let sections = frc.sections else { return 0 }
        
        return sections[section].numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let frc = messageModel?.frc else { return UITableViewCell() }
        let message = frc.object(at: indexPath)
        let direction: MessageDirection = message.senderId == myDataModel?.uuid ? .outcome : .income

        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: cellReuseId(for: direction),
            for: indexPath) as? MessageCell else {
                return UITableViewCell()
        }

        cell.contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
        cell.configure(with: MessageCellModel(text: message.content,
                                              date: message.created,
                                              sender: message.senderName,
                                              direction: direction))

        return cell
    }
    
    private func cellReuseId(for direction: MessageDirection) -> String {
        switch direction {
        case .income:
            return incomeCellId
        case .outcome:
            return outcomeCellId
        }
    }
}
//
//  ConversationViewController.swift
//  ChitChat02
//
//  Created by Timun on 28.09.2020.
//  Copyright © 2020 TimunInc. All rights reserved.
//

import UIKit

class ConversationViewController: UIViewController {

    static func instance() -> ConversationViewController? {
        let storyboard = UIStoryboard(name: "ConversationViewController", bundle: nil)
        return storyboard.instantiateInitialViewController() as? ConversationViewController
    }
    
    var channel: Channel?
    var dataManager: MessagesManager?
    
    private var messages: [MessageCellModel] = []
    
    private let nonameContact = "Noname"
    
    private let incomeCellId = "income-cell-id"
    private let outcomeCellId = "outcome-cell-id"

    @IBOutlet weak var messagesTableView: UITableView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var emptyLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        prepareUi()
        loadData()
        applyTheme()
    }
    
    private func prepareUi() {
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.startAnimating()
        
        emptyLabel.isHidden = true
        emptyLabel.text = "Looks like there are no messages in this channel"
        
        title = channel?.name ?? nonameContact
        
        messagesTableView.register(UINib(nibName: "IncomeMessageCell", bundle: nil), forCellReuseIdentifier: incomeCellId)
        messagesTableView.register(UINib(nibName: "OutcomeMessageCell", bundle: nil), forCellReuseIdentifier: outcomeCellId)
        messagesTableView.delegate = self
        messagesTableView.dataSource = self
        messagesTableView.transform = CGAffineTransform(scaleX: 1, y: -1)
    }
    
    private func loadData() {
        guard let channel = channel else { return }
        
        dataManager?.loadMessageList(from: channel) { [weak self] (values) in
            guard let self = self else { return }
            
            if !values.isEmpty {
                self.messages = values
                    .sorted { (prev, next) in
                        prev.created > next.created
                    }
                    .map { (message) in
                        let senderId = message.senderId
                        let direction: MessageDirection = senderId == "42" ? .outcome : .income

                        return MessageCellModel(
                            text: message.content,
                            date: message.created,
                            sender: senderId,
                            direction: direction)
                }
            } else {
                self.emptyLabel.isHidden = false
            }
            self.loadingIndicator.stopAnimating()
            self.messagesTableView.reloadData()
        }
    }
    
    private func applyTheme() {
        view.backgroundColor = ThemeManager.get().backgroundColor
    }
}

extension ConversationViewController: UITableViewDelegate {
    
}

extension ConversationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]

        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: cellReuseId(for: message.direction),
            for: indexPath) as? MessageCell else {
                return UITableViewCell()
        }

        cell.contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
        cell.configure(with: message)

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

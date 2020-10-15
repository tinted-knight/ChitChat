//
//  ConversationViewController.swift
//  ChitChat02
//
//  Created by Timun on 28.09.2020.
//  Copyright © 2020 TimunInc. All rights reserved.
//

import UIKit

class ConversationViewController: UIViewController {

    var contactName: String?
    
    private let nonameContact = "Noname"
    
    private let incomeCellId = "income-cell-id"
    private let outcomeCellId = "outcome-cell-id"

    @IBOutlet weak var messages: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        prepareUi()
        applyTheme()
    }
    
    private func prepareUi() {
        title = contactName ?? nonameContact
        
        messages.register(UINib(nibName: "IncomeMessageCell", bundle: nil), forCellReuseIdentifier: incomeCellId)
        messages.register(UINib(nibName: "OutcomeMessageCell", bundle: nil), forCellReuseIdentifier: outcomeCellId)
        messages.delegate = self
        messages.dataSource = self
        messages.transform = CGAffineTransform(scaleX: 1, y: -1)
    }
    
    private func applyTheme() {
        view.backgroundColor = ThemeManager.get().backgroundColor
    }
}

extension ConversationViewController: UITableViewDelegate {
    
}

extension ConversationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fakeMessages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = fakeMessages[indexPath.row]

        guard let cell = messages.dequeueReusableCell(
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

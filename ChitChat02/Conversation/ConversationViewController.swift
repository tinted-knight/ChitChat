//
//  ConversationViewController.swift
//  ChitChat02
//
//  Created by Timun on 28.09.2020.
//  Copyright © 2020 TimunInc. All rights reserved.
//

import UIKit

private let fakeMessages = [
    MessageCellModel(text: "message text 0", date: Date(), direction: .income),
    MessageCellModel(text: "message text 1", date: Date(), direction: .income),
    MessageCellModel(text: "message text 2", date: Date(), direction: .outcome),
    MessageCellModel(text: "message text 3", date: Date(), direction: .income),
    MessageCellModel(text: "message text 4", date: Date(), direction: .income),
]

class ConversationViewController: UIViewController {

    var contactName: String?
    
    private let nonameContact = "Noname"
    
    private let incomeCellId = "income-cell-id"
    private let outcomeCellId = "outcome-cell-id"

    @IBOutlet weak var messages: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareUi()
    }
    
    private func prepareUi() {
        title = contactName ?? nonameContact
        
        messages.register(UINib(nibName: "IncomeMessageCell", bundle: nil), forCellReuseIdentifier: incomeCellId)
        messages.register(UINib(nibName: "OutcomeMessageCell", bundle: nil), forCellReuseIdentifier: outcomeCellId)
        messages.delegate = self
        messages.dataSource = self
    }
}

extension ConversationViewController: UITableViewDelegate {
    
}

extension ConversationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fakeMessages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch fakeMessages[indexPath.row].direction {
            case .income:
                guard let cell = messages.dequeueReusableCell(withIdentifier: incomeCellId, for: indexPath) as? IncomeMessageCell else {
                    return UITableViewCell()
                }
                cell.configure(with: fakeMessages[indexPath.row])
                return cell
            case .outcome:
                guard let cell = messages.dequeueReusableCell(withIdentifier: outcomeCellId, for: indexPath) as? OutcomeMessageCell else {
                    return UITableViewCell()
                }
                cell.configure(with: fakeMessages[indexPath.row])
                return cell
        }
    }
    
    
}

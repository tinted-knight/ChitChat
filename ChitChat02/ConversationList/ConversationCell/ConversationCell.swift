//
//  ConversationCell.swift
//  ChitChat02
//
//  Created by Timun on 28.09.2020.
//  Copyright © 2020 TimunInc. All rights reserved.
//

import UIKit

protocol ConfigurableView {
    associatedtype ConfigurationModel
    
    func configure(with model: ConfigurationModel)
}

private let emptyMessage = "No messages yet"

class ConversationCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var profilePicture: UIImageView!
    
    private lazy var onlineColor: UIColor = UIColor.yellow.withAlphaComponent(0.2)
    private lazy var offlineColor: UIColor = .white

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension ConversationCell: ConfigurableView {
    
    func configure(with model: ConversationCellModel) {
        name.text = model.name
        populateLastMessage(with: model.message)
        reflectOnlineStatus(with: model.isOnline)
    }
    
    private func populateLastMessage(with value: String) {
        if value.isEmpty {
            message.text = emptyMessage
        } else {
            message.text = value
        }
    }
    
    private func reflectOnlineStatus(with isOnline: Bool) {
        if isOnline {
            backgroundColor = onlineColor
        } else {
            backgroundColor = offlineColor
        }
    }
}

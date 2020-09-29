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

    @IBOutlet weak var nameView: UILabel!
    @IBOutlet weak var dateView: UILabel!
    @IBOutlet weak var messageView: UILabel!
    @IBOutlet weak var profilePicture: UIImageView!
    
    private lazy var onlineColor: UIColor = UIColor.yellow.withAlphaComponent(0.2)
    private lazy var offlineColor: UIColor = .white

    private let formatter = DateFormatter()
    private let calendar = Calendar.current

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
        nameView.text = model.name
        populateLastMessage(with: model.message)
        reflectOnlineStatus(with: model.isOnline)
        // Debug: log last message date for each contact
//        let formatter = DateFormatter()
//        formatter.dateFormat = "dd MMM"
//        applog("\(model.name): \(formatter.string(from: model.date))")
        populateDateTime(with: model.date)
    }
    
    private func populateLastMessage(with value: String) {
        if value.isEmpty {
            messageView.text = emptyMessage
        } else {
            messageView.text = value
        }
    }
    
    private func reflectOnlineStatus(with isOnline: Bool) {
        if isOnline {
            backgroundColor = onlineColor
        } else {
            backgroundColor = offlineColor
        }
    }
    
    private func populateDateTime(with date: Date) {
        if calendar.startOfDay(for: date) != calendar.startOfDay(for: Date()) {
            formatter.dateFormat = "dd MMM"
        } else {
            formatter.dateFormat = "HH:mm"
        }
        
        dateView.text = formatter.string(from: date)
    }
}

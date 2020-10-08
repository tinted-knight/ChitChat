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
    
    private lazy var boldMessage = UIFont.systemFont(ofSize: 15, weight: .bold)

    private lazy var defaultFont: UIFont = UIFont.systemFont(ofSize: 13, weight: .regular)

    private lazy var noMessageFont: UIFont = {
        guard let font = UIFont(name: "Comfortaa-Light", size: 13) else {
            return UIFont.systemFont(ofSize: 13)
        }
        return UIFontMetrics.default.scaledFont(for: font)
    }()
    
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
    
    override func prepareForReuse() {
        backgroundColor = .white
        messageView.font = defaultFont
    }
    
}

extension ConversationCell: ConfigurableView {
    
    func configure(with model: ConversationCellModel) {
        nameView.text = model.name

        reflectOnlineStatus(with: model.isOnline)

        if model.message.isEmpty {
            renderNoLastMessage()
        } else {
            renderHasLastMessage(with: model)
        }
    }
    
    private func renderHasLastMessage(with model: ConversationCellModel) {
        messageView.text = model.message
        if model.hasUnreadMessages {
            messageView.font = boldMessage
        }
        displayDateTime(with: model.date)
    }
    
    private func renderNoLastMessage() {
        messageView.text = emptyMessage
        messageView.font = noMessageFont
        messageView.adjustsFontForContentSizeCategory = true
        
        dateView.isHidden = true
    }
    
    private func reflectOnlineStatus(with isOnline: Bool) {
        if isOnline {
            backgroundColor = onlineColor
        }
    }
    
    private func displayDateTime(with date: Date) {
        if calendar.startOfDay(for: date) != calendar.startOfDay(for: Date()) {
            formatter.dateFormat = "dd MMM"
        } else {
            formatter.dateFormat = "HH:mm"
        }
        
        dateView.text = formatter.string(from: date)
        dateView.isHidden = false
    }
}

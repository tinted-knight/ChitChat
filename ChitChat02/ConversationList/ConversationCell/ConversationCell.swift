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
    
    // deprecated
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
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        backgroundColor = ThemeManager.get().historyBgColor
        messageView.font = defaultFont
        super.prepareForReuse()
    }
    
}

extension ConversationCell: ConfigurableView {
    
    func configure(with model: Channel) {
        nameView.text = model.name

        if let lastMessage = model.lastMessage, !lastMessage.isEmpty {
            renderHasLastMessage(with: model)
        } else {
            renderNoLastMessage()
        }
    }
    
    private func renderHasLastMessage(with model: Channel) {
        messageView.text = model.lastMessage ?? "!!! no last message"
        displayDateTime(with: model.lastActivity)
    }
    
    private func renderNoLastMessage() {
        messageView.text = emptyMessage
        messageView.font = noMessageFont
        messageView.adjustsFontForContentSizeCategory = true
        
        dateView.isHidden = true
    }
    
    private func displayDateTime(with date: Date?) {
        guard let date = date else {
            dateView.isHidden = true
            return
        }
        if calendar.startOfDay(for: date) != calendar.startOfDay(for: Date()) {
            formatter.dateFormat = "dd MMM"
        } else {
            formatter.dateFormat = "HH:mm"
        }
        
        dateView.text = formatter.string(from: date)
        dateView.isHidden = false
    }
}

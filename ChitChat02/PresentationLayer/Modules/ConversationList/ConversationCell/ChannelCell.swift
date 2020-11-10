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
    
    func configure(with model: ConfigurationModel, theme: IThemeModel)
}

class ChannelCell: UITableViewCell {

    @IBOutlet weak var nameView: UILabel!
    @IBOutlet weak var dateView: UILabel!
    @IBOutlet weak var messageView: UILabel!
    @IBOutlet weak var profilePicture: UIImageView!
    
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
        messageView.font = defaultFont
        super.prepareForReuse()
    }
    
}

extension ChannelCell: ConfigurableView {
    
    func configure(with model: IChannelCellModel, theme: IThemeModel) {
        nameView.text = model.name
        backgroundColor = theme.getThemeData().backgroundColor

        if let lastMessage = model.lastMessage, !lastMessage.isEmpty {
            renderHasLastMessage(with: model)
        } else {
            renderNoLastMessage(with: model)
        }
    }
    
    private func renderHasLastMessage(with model: IChannelCellModel) {
        messageView.text = model.lastMessage ?? "!!! no last message"
        displayDateTime(with: model.lastActivity)
    }
    
    private func renderNoLastMessage(with model: IChannelCellModel) {
        messageView.text = model.emptyMessage
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

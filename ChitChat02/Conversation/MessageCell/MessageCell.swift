//
//  OutcomeMessageCell.swift
//  ChitChat02
//
//  Created by Timun on 28.09.2020.
//  Copyright © 2020 TimunInc. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {
    
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var background: UIView!
    
    private let formatter = DateFormatter()
    private let calendar = Calendar.current

    override func awakeFromNib() {
        super.awakeFromNib()
        
        background.layer.cornerRadius = 8.0
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

    private func formatDateTime(with date: Date) -> String {
        if calendar.startOfDay(for: date) != calendar.startOfDay(for: Date()) {
            formatter.dateFormat = "dd MMM"
        } else {
            formatter.dateFormat = "HH:mm"
        }
        return formatter.string(from: date)
    }
}

extension MessageCell: ConfigurableView {
    func configure(with model: MessageCellModel) {
        message.text = model.text
        date.text = formatDateTime(with: model.date)
        switch model.direction {
            case .income:
                background.backgroundColor = ThemeManager.get().incomeBgColor
                message.textColor = ThemeManager.get().incomeTextColor
            case .outcome:
                background.backgroundColor = ThemeManager.get().outcomeBgColor
                message.textColor = ThemeManager.get().outcomeTextColor
        }
    }
}

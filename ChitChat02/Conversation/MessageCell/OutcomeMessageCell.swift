//
//  OutcomeMessageCell.swift
//  ChitChat02
//
//  Created by Timun on 28.09.2020.
//  Copyright © 2020 TimunInc. All rights reserved.
//

import UIKit

class OutcomeMessageCell: UITableViewCell {

    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var date: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

extension OutcomeMessageCell: ConfigurableView {
    func configure(with model: MessageCellModel) {
        message.text = model.text
    }
}
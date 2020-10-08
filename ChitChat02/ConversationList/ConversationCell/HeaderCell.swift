//
//  HeaderCell.swift
//  ChitChat02
//
//  Created by Timun on 29.09.2020.
//  Copyright © 2020 TimunInc. All rights reserved.
//

import UIKit

class HeaderCell: UITableViewCell {
    
    @IBOutlet weak var textView: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

extension HeaderCell: ConfigurableView {
    func configure(with model: String) {
        textView.text = model
    }
}

//
//  AvatarViewCell.swift
//  ChitChat02
//
//  Created by Timun on 16.11.2020.
//  Copyright © 2020 TimunInc. All rights reserved.
//

import UIKit

class AvatarViewCell: UICollectionViewCell {

    @IBOutlet weak var image: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}

extension AvatarViewCell {
    func configure(with model: String) {
        Log.net("Cell configure with: \(model)")
    }
}

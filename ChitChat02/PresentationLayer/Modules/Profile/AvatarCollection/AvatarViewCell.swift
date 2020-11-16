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
    @IBOutlet weak var author: UILabel!
    
    private(set) var hasLoaded: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.author.textColor = .white
    }

    override func prepareForReuse() {
        hasLoaded = false
        super.prepareForReuse()
    }
    
}

extension AvatarViewCell {
    
    func configure(with item: AvatarInfo, model: IAvatarListModel) {
        image.image = UIImage(named: "Placeholder")
        author.text = item.author
        model.load(id: item.id) { [weak self] (image) in
            Log.net("cell image id = \(item.id)")
            if let image = image {
                self?.image.image = image
                self?.hasLoaded = true
            }
        }
    }
}

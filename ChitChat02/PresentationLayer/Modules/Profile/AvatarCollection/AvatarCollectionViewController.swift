//
//  AvatarCollectionViewController.swift
//  ChitChat02
//
//  Created by Timun on 16.11.2020.
//  Copyright © 2020 TimunInc. All rights reserved.
//

import Foundation
import UIKit

protocol AvatarCollectionDelegate: class {
    func onPicked(_ image: UIImage)
}

class AvatarCollectionViewController: UIViewController {
    
    private let reuseId = "avatar-cell"
    
    private let sectionInsets = UIEdgeInsets(top: 20.0,
                                             left: 20.0,
                                             bottom: 20.0,
                                             right: 20.0)
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var model: IAvatarListModel
    
    private weak var delegate: AvatarCollectionDelegate?
    
    init(_ model: IAvatarListModel, delegate: AvatarCollectionDelegate) {
        self.model = model
        self.delegate = delegate
        super.init(nibName: "AvatarCollectionViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        model.delegate = self
        model.loadData()
        
        collectionView.register(UINib(nibName: "AvatarViewCell", bundle: nil), forCellWithReuseIdentifier: reuseId)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
}

extension AvatarCollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model.values.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseId, for: indexPath) as? AvatarViewCell else {
            return UICollectionViewCell()
        }
        
        cell.configure(with: model.values[indexPath.row], model: model)
        return cell
    }
}

extension AvatarCollectionViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? AvatarViewCell else { return }
        guard cell.hasLoaded, let image = cell.image.image else { return }
        delegate?.onPicked(image)
        dismiss(animated: true, completion: nil)
    }
}

extension AvatarCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (3 + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / 3
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}

extension AvatarCollectionViewController: IAvatarListModelDelegate {
    func onData(_ values: [AvatarInfo]) {
        collectionView.reloadData()
//        values.forEach { (avatar) in
//            Log.net("\(avatar.id), \(avatar.author)")
//        }
    }
}

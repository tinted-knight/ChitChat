//
//  IAvatarListModel.swift
//  ChitChat02
//
//  Created by Timun on 16.11.2020.
//  Copyright © 2020 TimunInc. All rights reserved.
//

import Foundation
import UIKit

protocol IAvatarListModel {
    var delegate: IAvatarListModelDelegate? { get set }
    
    var values: [AvatarInfo] { get }
    
    func loadData()
    
    func load(id: String, completion: @escaping (UIImage?) -> Void)
}

protocol IAvatarListModelDelegate: class {
    func onLoading()
    func onData(_ values: [AvatarInfo])
}

class AvatarListModel: IAvatarListModel {
    private let service: IAvatarService
    
    var values: [AvatarInfo] = []
    
    weak var delegate: IAvatarListModelDelegate?
    
    init(with service: IAvatarService) {
        self.service = service
    }
    
    func loadData() {
        delegate?.onLoading()
        service.getList { [weak self] (values) in
            self?.values = values
            // fake: delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self?.delegate?.onData(values)
            }
        }
    }
    
    func load(id: String, completion: @escaping (UIImage?) -> Void) {
        service.loadImage(id) { (data) in
            guard let data = data, let image = UIImage(data: data) else {
                completion(nil)
                return
            }
            // fake: delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                completion(image)
            }
        }
    }
}

//
//  IAvatarListModel.swift
//  ChitChat02
//
//  Created by Timun on 16.11.2020.
//  Copyright © 2020 TimunInc. All rights reserved.
//

import Foundation
import UIKit
// MARK: Protocol
protocol IAvatarListModel {
    var delegate: IAvatarListModelDelegate? { get set }
    
    var values: [AvatarInfo] { get }
    
    func loadData()
    
    func load(id: String, completion: @escaping (UIImage?) -> Void)
}
// MARK: Delegate protocol
protocol IAvatarListModelDelegate: class {
    func onLoading()
    func onData(_ values: [AvatarInfo])
}
// MARK: Implementation
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
            DispatchQueue.main.async {
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
            DispatchQueue.main.async {
                completion(image)
            }
        }
    }
}

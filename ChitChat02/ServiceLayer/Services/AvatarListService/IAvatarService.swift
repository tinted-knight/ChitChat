//
//  IAvatarService.swift
//  ChitChat02
//
//  Created by Timun on 16.11.2020.
//  Copyright © 2020 TimunInc. All rights reserved.
//

import Foundation

struct AvatarInfo {
    let id: String
    let author: String
    let url: String
    let downloadUrl: String
}

protocol IAvatarService {
    func getList(completion: @escaping ([AvatarInfo]) -> Void)
    
    func loadImage(_ string: String, completion: @escaping (Data?) -> Void)
}

class AvatarService: IAvatarService {
    private let manager: IRequestManager
    private let config: RequestConfig<AvatarListParser>
    
    init(manager: IRequestManager) {
        self.manager = manager
        self.config = RequestConfig(request: AvatarListRequest(), parser: AvatarListParser())
    }
    
    func getList(completion: @escaping ([AvatarInfo]) -> Void) {
        manager.send(requestConfig: config) { (result) in
            switch result {
            case .error(let e): do {
                Log.net(e)
                completion([])
            }
            case .success(let values): do {
                completion(values.map { (apiModel) -> AvatarInfo in
                    return AvatarInfo(id: apiModel.id,
                                      author: apiModel.author,
                                      url: apiModel.url,
                                      downloadUrl: apiModel.downloadUrl)
                })
            }
            }
        }
    }
    
    func loadImage(_ id: String, completion: @escaping (Data?) -> Void) {
        let config = RequestConfig(request: ImageRequest(from: id), parser: ImageParser())
        manager.send(requestConfig: config) { (result) in
            switch result {
            case .error(let e): do {
                Log.net(e)
                completion(nil)
            }
            case .success(let image): do {
                completion(image)
            }
            }
        }
    }
}

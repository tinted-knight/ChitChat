//
//  AvatarListRequests.swift
//  ChitChat02
//
//  Created by Timun on 17.11.2020.
//  Copyright © 2020 TimunInc. All rights reserved.
//

import Foundation

class PicsumRequest {
    fileprivate let base: String
    
    init() {
        do {
            let url: String = try Configuration.value(for: "API_URL_AVATAR_LIST")
            base = "https://" + url
            Log.net("Got key from xcconfig, \(url), \(base)")
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}

class AvatarListRequest: PicsumRequest, IRequest {
    private let imageListPath = "/v2/list"
    private let initPage = "1"
    private let limit = "100"
    
    lazy var urlRequest: URLRequest? = {
        let path = self.base + self.imageListPath
        let params = "page=\(self.initPage)&limit=\(self.limit)"
        let urlString = "\(path)?\(params)"
        
        guard let url = URL(string: urlString) else {
            return nil
        }
        return URLRequest(url: url)
    }()
}

class ImageRequest: PicsumRequest, IRequest {
    private let idPath = "/id"
    private let width = 200
    private let id: String
    
    init(from id: String) {
        self.id = id
        super.init()
    }
    
    lazy var urlRequest: URLRequest? = {
        let path = self.base + self.idPath + "/" + id
        let imageSizeParams = "/\(self.width)/\(self.width)"
        let urlString = path + imageSizeParams
        
        guard let url = URL(string: urlString) else {
            return nil
        }
        return URLRequest(url: url)
    }()
}

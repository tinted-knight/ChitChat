//
//  IRequest.swift
//  ChitChat02
//
//  Created by Timun on 16.11.2020.
//  Copyright © 2020 TimunInc. All rights reserved.
//

import Foundation

protocol IRequest {
    var urlRequest: URLRequest? { get }
}

class AvatarListRequest: IRequest {
    private let base = "https://picsum.photos/v2/list"
    private let initPage = "1"
    private let limit = "100"
    
    lazy var urlRequest: URLRequest? = {
        let urlString = "\(base)?page=\(self.initPage)&limit=\(self.limit)"
        guard let url = URL(string: urlString) else {
            return nil
        }
        return URLRequest(url: url)
    }()
}

class ImageRequest: IRequest {
    private let urlString: String
    private let width = 200
    
    init(from id: String) {
        self.urlString = "https://picsum.photos/id/\(id)/\(self.width)/\(self.width)"
    }
    
    lazy var urlRequest: URLRequest? = {
        guard let url = URL(string: self.urlString) else {
            return nil
        }
        return URLRequest(url: url)
    }()
}

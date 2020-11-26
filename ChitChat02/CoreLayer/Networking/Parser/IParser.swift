//
//  IParser.swift
//  ChitChat02
//
//  Created by Timun on 16.11.2020.
//  Copyright © 2020 TimunInc. All rights reserved.
//

import Foundation

protocol IParser {
    associatedtype Model
    func parse(data: Data) -> Model?
}

struct AvatarListApiModel: Codable {
    let items: [AvatarItemApiModel]
}

struct AvatarItemApiModel: Codable {
    let id: String
    let author: String
    let url: String
    let downloadUrl: String
    
    private enum CodingKeys: String, CodingKey {
        case id, author, url, downloadUrl = "download_url"
    }
}

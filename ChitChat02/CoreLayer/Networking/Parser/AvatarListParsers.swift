//
//  AvatarParser.swift
//  ChitChat02
//
//  Created by Timun on 17.11.2020.
//  Copyright © 2020 TimunInc. All rights reserved.
//

import Foundation

class AvatarListParser: IParser {
    typealias Model = [AvatarItemApiModel]
    
    func parse(data: Data) -> [AvatarItemApiModel]? {
        do {
            let avatarList = try JSONDecoder().decode([AvatarItemApiModel].self, from: data)
            return avatarList
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}

class ImageParser: IParser {
    typealias Model = Data
    
    func parse(data: Data) -> Data? {
        return data
    }
}

//
//  Repo.swift
//  ChitChat02
//
//  Created by Timun on 09.10.2020.
//  Copyright © 2020 TimunInc. All rights reserved.
//

import Foundation

protocol DataManager {
//    var user: UserModel { get }
    var delegate: DataManagerDelegate? { get set }
    
//    func save(_ model: UserModel, avatar: Data?)
    func save(name: String?, description: String?, avatar: Data?)
    func load()
}

protocol DataManagerDelegate {
    func onLoaded(_ model: UserModel)
    func onLoadError(_ message: String)

    func onSaved()
    func onSaveError(_ message: String)
}

extension DataManager {
    private func storageUrl() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func nameUrl() -> URL {
        var url = storageUrl()
        url.appendPathComponent("user_name.txt")
        applog("nameUrl: \(url.path)")
        return url
    }

    func descriptionUrl() -> URL {
        var url = storageUrl()
        url.appendPathComponent("user_description.txt")
        applog("descriptionUrl: \(url.path)")
        return url
    }

    func avatarUrl() -> URL {
        var url = storageUrl()
        url.appendPathComponent("user_avatar.txt")
        applog("avatarUrl: \(url.path)")
        return url
    }
}

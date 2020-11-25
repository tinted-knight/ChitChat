//
//  IDataManager.swift
//  ChitChat02
//
//  Created by Timun on 09.11.2020.
//  Copyright © 2020 TimunInc. All rights reserved.
//

import Foundation

protocol IDataManager {
    var delegate: IDataManagerDelegate? { get set }
    
    func save(name: String?, description: String?, avatar: Data?)
    func load()
}

protocol IDataManagerDelegate {
    func onLoaded(_ model: UserModel)
    func onLoadError(_ message: String)

    func onSaved()
    func onSaveError(_ message: String)
}

extension IDataManager {
    private func storageUrl() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func nameUrl() -> URL {
        var url = storageUrl()
        url.appendPathComponent("user_name.txt")
        return url
    }

    func descriptionUrl() -> URL {
        var url = storageUrl()
        url.appendPathComponent("user_description.txt")
        return url
    }

    func avatarUrl() -> URL {
        var url = storageUrl()
        url.appendPathComponent("user_avatar.txt")
        return url
    }
}

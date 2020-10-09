//
//  Repo.swift
//  ChitChat02
//
//  Created by Timun on 09.10.2020.
//  Copyright © 2020 TimunInc. All rights reserved.
//

import Foundation

protocol DataManager {
    var user: UserModel { get }
    func save(_ model: UserModel, onDone: @escaping () -> Void, onError: @escaping (String) -> Void)
    func load(onLoaded: @escaping (UserModel) -> Void, onError: @escaping (String) -> Void)
}

class GCDDataManager: DataManager {
    private let queue = DispatchQueue(label: "file-operations", qos: .utility)
    let fakeDelay = 1.0

    var user: UserModel = newUser
    
    func save(_ model: UserModel, onDone: @escaping () -> Void, onError: @escaping (String) -> Void) {
        queue.asyncAfter(deadline: .now() + fakeDelay) { [weak self, user] in
            guard let nameUrl = self?.nameUrl, let descriptionUrl = self?.descriptionUrl else {
                onError("Не удалось сохранить данные")
                return
            }
            do {
                var nameUpdated: String?
                var descUpdated: String?
                if model.name != user.name {
                    try model.name.write(to: nameUrl, atomically: true, encoding: .utf8)
                    nameUpdated = model.name
                    applog("name saved")
                }
                if model.description != user.description {
                    try model.description.write(to: descriptionUrl, atomically: true, encoding: .utf8)
                    descUpdated = model.description
                    applog("desc saved")
                }
                self?.user = UserModel(
                    name: nameUpdated ?? user.name,
                    description: descUpdated ?? user.description
                )
                onDone()
            } catch {
                onError("Не удалось сохранить данные")
            }
        }
    }
    
    func load(onLoaded: @escaping (UserModel) -> Void, onError: @escaping (String) -> Void) {
        queue.asyncAfter(deadline: .now() + fakeDelay) { [weak self] in
            guard let nameUrl = self?.nameUrl, let descriptionUrl = self?.descriptionUrl else {
                onError("load: find storage error")
                return
            }
            do {
                let name = try String(contentsOf: nameUrl)
                let description = try String(contentsOf: descriptionUrl)

                let loaded = UserModel(name: name, description: description)
                self?.user = loaded
                onLoaded(loaded)
            } catch {
                onError("load error")
            }
        }
    }
    
    private func storageUrl() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    private lazy var nameUrl: URL = {
        var url = storageUrl()
        url.appendPathComponent("user_name.txt")
        return url
    }()

    private lazy var descriptionUrl: URL = {
        var url = storageUrl()
        url.appendPathComponent("user_description.txt")
        return url
    }()
}

//
//  GCDDataManager.swift
//  ChitChat02
//
//  Created by Timun on 09.10.2020.
//  Copyright © 2020 TimunInc. All rights reserved.
//

import Foundation

class GCDDataManager: DataManager {
    private let queue = DispatchQueue(label: "file-operations", qos: .utility)
    let fakeDelay = 1.0

    var user: UserModel = newUser
    var delegate: DataManagerDelegate?
    
    func save(_ model: UserModel) {
        queue.asyncAfter(deadline: .now() + fakeDelay) { [weak self, user] in
            guard let nameUrl = self?.nameUrl(), let descriptionUrl = self?.descriptionUrl() else {
                self?.delegate?.onSaveError("Не удалось сохранить данные")
                return
            }
            do {
                var nameUpdated: String?
                var descUpdated: String?
                if model.name != user.name {
                    try model.name.write(to: nameUrl, atomically: true, encoding: .utf8)
                    nameUpdated = model.name
                }
                if model.description != user.description {
                    try model.description.write(to: descriptionUrl, atomically: true, encoding: .utf8)
                    descUpdated = model.description
                }
                self?.user = UserModel(
                    name: nameUpdated ?? user.name,
                    description: descUpdated ?? user.description
                )
                self?.delegate?.onSaved()
            } catch {
                self?.delegate?.onSaveError("Не удалось сохранить данные")
            }
        }
    }
    
    func load() {
        queue.asyncAfter(deadline: .now() + fakeDelay) { [weak self] in
            guard let nameUrl = self?.nameUrl(), let descriptionUrl = self?.descriptionUrl() else {
                self?.delegate?.onLoadError("load: find storage error")
                return
            }
            do {
                let name = try String(contentsOf: nameUrl)
                let description = try String(contentsOf: descriptionUrl)

                let loaded = UserModel(name: name, description: description)
                self?.user = loaded
                self?.delegate?.onLoaded(loaded)
            } catch {
                self?.delegate?.onLoadError("load error")
            }
        }
    }
}

//
//  GCDDataManager.swift
//  ChitChat02
//
//  Created by Timun on 09.10.2020.
//  Copyright © 2020 TimunInc. All rights reserved.
//

import Foundation

private enum SaveResult {
    case success
    case error
}

class GCDDataManager: IDataManager {
    private let queue = DispatchQueue(label: "file-operations", qos: .utility, attributes: .concurrent)
    // delay, чтобы увидеть инидикатор прогресса на экране
    let fakeDelay = 1.0
    let doubleDelay = 2.0

    var delegate: IDataManagerDelegate?

    private var nameResult: SaveResult = .success
    private var descResult: SaveResult = .success
    private var avatarResult: SaveResult = .success

    func save(name: String?, description: String?, avatar: Data?) {
        applog("gcd save")

        let group = DispatchGroup()
        if let avatar = avatar {
            performAvatarTask(group, avatar: avatar)
        }
        
        if let name = name {
            perforNameTask(group, name: name)
        }

        if let description = description {
            perforDescriptionTask(group, description: description)
        }

        group.notify(queue: queue) { [weak self] in
            guard self?.nameResult == .success, self?.descResult == .success,
                self?.avatarResult == .success else {
                self?.delegate?.onSaveError("Не все данные удалось сохранить")
                return
            }
            self?.delegate?.onSaved()
        }
    }

    func load() {
        applog("gcd load")
        queue.asyncAfter(deadline: .now() + fakeDelay) { [weak self] in
            guard let nameUrl = self?.nameUrl(), let descriptionUrl = self?.descriptionUrl() else {
                self?.delegate?.onLoadError("load: find storage error")
                return
            }
            do {
                let name = try String(contentsOf: nameUrl)
                applog("gcd load name: \(name)")
                let description = try String(contentsOf: descriptionUrl)
                applog("gcd load desc: \(description)")

                let loaded = UserModel(name: name, description: description, avatar: self?.avatarUrl())
                self?.delegate?.onLoaded(loaded)
            } catch {
                self?.delegate?.onLoadError(error.localizedDescription)
            }
        }
    }
    
    private func performAvatarTask(_ group: DispatchGroup, avatar: Data) {
        applog("avatar task")
        group.enter()
        queue.asyncAfter(deadline: .now() + fakeDelay) { [weak self] in
            guard let avatarUrl = self?.avatarUrl() else {
                self?.avatarResult = .error
                group.leave()
                return
            }
            do {
                try avatar.write(to: avatarUrl)
                //                    avatarResult = .error
                self?.avatarResult = .success
                group.leave()
            } catch {
                self?.avatarResult = .error
                group.leave()
            }
        }
    }

    private func perforNameTask(_ group: DispatchGroup, name: String) {
        applog("name task: \(name)")
        group.enter()
        queue.asyncAfter(deadline: .now() + doubleDelay) { [weak self] in
            guard let nameUrl = self?.nameUrl() else {
                self?.nameResult = .error
                group.leave()
                return
            }
            do {
                try name.write(to: nameUrl, atomically: true, encoding: .utf8)
                self?.nameResult = .success
                group.leave()
            } catch {
                self?.nameResult = .error
                group.leave()
                return
            }
        }
    }

    private func perforDescriptionTask(_ group: DispatchGroup, description: String) {
        applog("description task")
        group.enter()
        queue.asyncAfter(deadline: .now() + fakeDelay) { [weak self] in
            guard let descUrl = self?.descriptionUrl() else {
                self?.descResult = .error
                group.leave()
                return
            }
            do {
                try description.write(to: descUrl, atomically: true, encoding: .utf8)
                self?.descResult = .success
                group.leave()
            } catch {
                self?.descResult = .error
                group.leave()
                return
            }
        }
    }
}

//
//  GCDDataManager.swift
//  ChitChat02
//
//  Created by Timun on 09.10.2020.
//  Copyright © 2020 TimunInc. All rights reserved.
//

import Foundation

private enum TestError: Error {
    case name
    case desc
}

private enum SaveResult {
    case success
    case error
}

class GCDDataManager: DataManager {
    private let queue = DispatchQueue(label: "file-operations", qos: .utility, attributes: .concurrent)
    // delay, чтобы увидеть инидикатор прогресса на экране
    let fakeDelay = 1.0
    let doubleDelay = 2.0

    var user: UserModel = newUser
    var delegate: DataManagerDelegate?
    
    func save(_ model: UserModel) {
        var name: SaveResult = .success
        var desc: SaveResult = .success
        
        let group = DispatchGroup()
        
        if model.name != user.name {
            group.enter()
            queue.asyncAfter(deadline: .now() + doubleDelay) { [weak self] in
                guard let nameUrl = self?.nameUrl() else {
                    name = .error
                    group.leave()
                    return
                }
                do {
                    try model.name.write(to: nameUrl, atomically: true, encoding: .utf8)
                    group.leave()
                } catch {
                    name = .error
                    group.leave()
                    return
                }
            }
        }
        
        if model.description != user.description {
            group.enter()
            queue.asyncAfter(deadline: .now() + fakeDelay) { [weak self] in
                guard let descUrl = self?.descriptionUrl() else {
                    desc = .error
                    group.leave()
                    return
                }
                do {
                    try model.description.write(to: descUrl, atomically: true, encoding: .utf8)
                    group.leave()
                } catch {
                    desc = .error
                    group.leave()
                    return
                }
            }
        }
        
        group.notify(queue: queue) { [weak self, user] in
            guard name == .success, desc == .success else {
                // если одно из полей удалось сохранить,
                // запишем в user, чтобы показать пользователю
                self?.user = UserModel(
                    name: name == .success ? model.name : user.name,
                    description: desc == .success ? model.description : user.description
                )
                self?.delegate?.onSaveError("Не все данные удалось сохранить")
                return
            }
            // оба поля удалось сохранить
            self?.user = UserModel(
                name: model.name,
                description: model.description
            )
            self?.delegate?.onSaved()
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
//                throw TestError.name
                let description = try String(contentsOf: descriptionUrl)

                let loaded = UserModel(name: name, description: description)
                self?.user = loaded
                self?.delegate?.onLoaded(loaded)
            } catch TestError.name {
                self?.delegate?.onLoadError("name error")
            } catch TestError.desc {
                self?.delegate?.onLoadError("desc error")
            } catch {
                self?.delegate?.onLoadError(error.localizedDescription)
            }
        }
    }
}

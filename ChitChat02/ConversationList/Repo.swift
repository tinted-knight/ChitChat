//
//  Repo.swift
//  ChitChat02
//
//  Created by Timun on 09.10.2020.
//  Copyright © 2020 TimunInc. All rights reserved.
//

import Foundation

protocol Repository {
    //
    func save(_ model: UserModel, onDone: @escaping () -> Void, onError: @escaping (String) -> Void)
    func load(onLoaded: @escaping (UserModel) -> Void, onError: @escaping (String) -> Void)
}

class GCDRepo: Repository {
    private let queue = DispatchQueue(label: "file-operations", qos: .utility)
    let fakeDelay = 1.0

    func save(_ model: UserModel, onDone: @escaping () -> Void, onError: @escaping (String) -> Void) {
        queue.asyncAfter(deadline: .now() + fakeDelay) { [weak self] in
            guard let storageUrl = self?.storageUrl else {
                onError("find storage error")
                return
            }
            do {
                let value = model.name + "|" + model.description
                try value.write(to: storageUrl, atomically: true, encoding: .utf8)
                onDone()
            } catch {
                onError("write error")
            }
        }
    }
    
    func load(onLoaded: @escaping (UserModel) -> Void, onError: @escaping (String) -> Void) {
        queue.asyncAfter(deadline: .now() + fakeDelay) { [weak self] in
            guard let storageUrl = self?.storageUrl else {
                onError("error|error")
                return
            }
            do {
                let loaded = try String(contentsOf: storageUrl)
                let values = loaded.components(separatedBy: "|")
                if (values.count != 2) {
                    onError("split error")
                    return
                }
                onLoaded(UserModel(name: values[0], description: values[1]))
            } catch {
                onError("catch|catch")
            }
        }
    }
    
    private lazy var storageUrl: URL = {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        var dir = paths[0]
        dir.appendPathComponent("user_profile.txt")
        return dir
    }()
}

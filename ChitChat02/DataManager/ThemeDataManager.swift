//
//  ThemeDataManager.swift
//  ChitChat02
//
//  Created by Timun on 10.10.2020.
//  Copyright © 2020 TimunInc. All rights reserved.
//

import Foundation

class ThemeDataManager {
    private let queue = DispatchQueue(label: "theme", qos: .utility)
    
    func save(_ theme: ThemeModel) {
        applog("tdm save")
        queue.async { [weak self] in
            guard let themeUrl = self?.themeUrl() else {
                applog("ThemeDataManager return error")
                return
            }
            do {
                if let encoded = try? JSONEncoder().encode(ThemeManager.get()) {
                    try encoded.write(to: themeUrl)
                    applog("theme saved: \(theme.name)")
                }
            } catch {
                applog("save theme error")
            }
        }
    }

    func load(onDone: @escaping (ThemeModel) -> Void, onError: @escaping () -> Void) {
        DispatchQueue.global().async { [weak self] in
            guard let themeUrl = self?.themeUrl() else {
                onError()
                return
            }
            do {
                let data = try Data(contentsOf: themeUrl)
                let theme = try JSONDecoder().decode(ThemeModel.self, from: data)
                onDone(theme)
            } catch {
                applog("error loading theme")
                onError()
            }
        }
    }
    
    private func themeUrl() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        var url = paths[0]
        url.appendPathComponent("user_theme.txt")
        return url
    }
}

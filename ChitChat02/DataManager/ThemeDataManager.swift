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
    
    private let themeData: AppThemeData
    
    init(data: AppThemeData) {
        self.themeData = data
    }
    
    func save(_ theme: AppThemeData) {
        queue.async { [weak self] in
            guard let self = self else { return }
            do {
                if let encoded = try? JSONEncoder().encode(self.themeData) {
                    try encoded.write(to: self.themeUrl())
                    applog("theme saved: \(theme.name)")
                }
            } catch {
                applog("save theme error")
            }
        }
    }

    func load(onDone: @escaping (AppThemeData) -> Void, onError: @escaping () -> Void) {
        DispatchQueue.global().async { [weak self] in
            guard let themeUrl = self?.themeUrl() else {
                onError()
                return
            }
            do {
                let data = try Data(contentsOf: themeUrl)
                let theme = try JSONDecoder().decode(AppThemeData.self, from: data)
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

//
//  LoadOperation.swift
//  ChitChat02
//
//  Created by Timun on 10.10.2020.
//  Copyright © 2020 TimunInc. All rights reserved.
//

import Foundation

enum LoadStringResult {
    case success(_ value: String)
    case error(_ error: String)
}

class LoadStringOperation: Operation {
    var from: URL?
    private(set) var result: LoadStringResult?
    
    override func main() {
        guard let from = from, !isCancelled else {
            result = .error("load string error")
            return
        }
        do {
            let value = try String(contentsOf: from)
            result = .success(value)
        } catch {
            result = .error(error.localizedDescription)
        }
    }
}

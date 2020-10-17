//
//  SaveOperation.swift
//  ChitChat02
//
//  Created by Timun on 10.10.2020.
//  Copyright © 2020 TimunInc. All rights reserved.
//

import Foundation

internal enum SaveOperationResult {
    case success
    case error(_ value: String)
}

class ResultOperation: Operation {
    var result: SaveOperationResult?
    override func main() {
        result = .success
    }
}

class SaveStringOperation: ResultOperation {
    var to: URL?
    var value: String?
    
    override func main() {
        guard let to = to, !isCancelled, let value = value else {
            result = .error("save error")
            return
        }
        do {
            try value.write(to: to, atomically: true, encoding: .utf8)
            result = .success
        } catch {
            result = .error(error.localizedDescription)
        }
    }
}

class SaveDataOperation: ResultOperation {
    var to: URL?
    var value: Data?
    
    override func main() {
        applog("operation save avatar")
        guard let to = to, !isCancelled, let value = value else {
            result = .error("save data error")
            return
        }
        do {
            try value.write(to: to)
            result = .success
        } catch {
            result = .error(error.localizedDescription)
        }
    }
}

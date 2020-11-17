//
//  IRequestManager.swift
//  ChitChat02
//
//  Created by Timun on 16.11.2020.
//  Copyright © 2020 TimunInc. All rights reserved.
//

import Foundation

struct RequestConfig<Parser> where Parser: IParser {
    let request: IRequest
    let parser: Parser
}

enum Result<Model> {
    case success(Model)
    case error(String)
}

protocol IRequestManager {
    func send<Parser>(requestConfig: RequestConfig<Parser>,
                      completion: @escaping (Result<Parser.Model>) -> Void)
}

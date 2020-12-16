//
//  RequestManagerMocks.swift
//  ChitChat02Tests
//
//  Created by Timun on 30.11.2020.
//  Copyright © 2020 TimunInc. All rights reserved.
//

@testable import ChitChat02

class AvatarManagerMock: IRequestManager {
    
    var sendCalls = 0
    var request: IRequest?
    
    func send<Parser>(requestConfig: RequestConfig<Parser>,
                      completion: @escaping (Result<Parser.Model>) -> Void) where Parser: IParser {
        self.sendCalls += 1
        self.request = requestConfig.request
    }
}

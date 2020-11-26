//
//  AvatarRequestManager.swift
//  ChitChat02
//
//  Created by Timun on 17.11.2020.
//  Copyright © 2020 TimunInc. All rights reserved.
//

import Foundation

class AvatarRequestManager: IRequestManager {
    private let session = URLSession.shared
    
    func send<Parser>(requestConfig: RequestConfig<Parser>,
                      completion: @escaping (Result<Parser.Model>) -> Void) {
        guard let urlRequest = requestConfig.request.urlRequest else {
            completion(.error("cannot parse url"))
            return
        }
        let task = session.dataTask(with: urlRequest) { (data, _, error) in
            if let error = error {
                completion(.error(error.localizedDescription))
                return
            }
            guard let data = data,
                let parsed: Parser.Model = requestConfig.parser.parse(data: data) else {
                    completion(.error("cannot parse data"))
                    return
            }
            completion(.success(parsed))
        }
        task.resume()
    }
}

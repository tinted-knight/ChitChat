//
//  ConfigurationTest.swift
//  ChitChat02Tests
//
//  Created by Timun on 09.12.2020.
//  Copyright © 2020 TimunInc. All rights reserved.
//

import Foundation
import XCTest

class ConfTest: XCTestCase {
    func testConfig() {
        guard
            let object = Bundle.main.object(forInfoDictionaryKey: "API_URL_AVATAR_LIST") else {
                XCTFail("missing key")
                return
        }
        XCTAssert(object is String)
        guard let url = object as? String else {
            XCTFail("not string")
            return
        }
        XCTAssertEqual(url, "picsum.photos")
    }
}

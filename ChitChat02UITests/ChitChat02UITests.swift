//
//  ChitChat02UITests.swift
//  ChitChat02UITests
//
//  Created by Timun on 29.11.2020.
//  Copyright © 2020 TimunInc. All rights reserved.
//

import XCTest

class ChitChat02UITests: XCTestCase {

    func testTextFields() throws {
        let app = XCUIApplication()
        app.launch()
        
        let button = app.navigationBars.buttons["Profile button"]
        _ = button.waitForExistence(timeout: 5)
        button.tap()
        
        let userName = app.textFields["Text User Name"]
        let userDescription = app.textViews["Text User Description"]
        XCTAssert(userName.waitForExistence(timeout: 2))
        XCTAssert(userDescription.waitForExistence(timeout: 2))
    }
}

//
//  DateTests.swift
//  BringChuChubaTests
//
//  Created by 홍다희 on 2021/02/03.
//

import XCTest

class DateTests: XCTestCase {

    override func setUpWithError() throws {
        super.setUp()
    }

    override func tearDownWithError() throws {
        super.tearDown()
    }

    func testDate_isInThisMonth() throws {
        let date = Date().toString
        XCTAssertTrue(date.toDate.isDateInThisMonth)
    }

    func testDate_isNotInThisMonth() throws {
        let date = "2021-01-03 11:30"
        XCTAssertFalse(date.toDate.isDateInThisMonth)
    }

}

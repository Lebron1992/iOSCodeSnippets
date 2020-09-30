//
//  IntExtensionsTests.swift
//  iOSCodeSnippetsTests
//
//  Created by 曾文志 on 2020/9/30.
//  Copyright © 2020 Lebron. All rights reserved.
//

import XCTest
@testable import iOSCodeSnippets

class IntExtensionsTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testAbbrevation() {
        XCTAssertEqual(598.abbrevation(), "598")
        XCTAssertEqual((-999).abbrevation(), "-999")
        XCTAssertEqual(1000.abbrevation(), "1K")
        XCTAssertEqual((-1284).abbrevation(), "-1.3K")
        XCTAssertEqual(9940.abbrevation(), "9.9K")
        XCTAssertEqual(9980.abbrevation(), "10K")
        XCTAssertEqual(39900.abbrevation(), "39.9K")
        XCTAssertEqual(99880.abbrevation(), "99.9K")
        XCTAssertEqual(399880.abbrevation(), "0.4M")
        XCTAssertEqual(999898.abbrevation(), "1M")
        XCTAssertEqual(999999.abbrevation(), "1M")
        XCTAssertEqual(1456384.abbrevation(), "1.5M")
        XCTAssertEqual(12383474.abbrevation(), "12.4M")
        XCTAssertEqual(123834741.abbrevation(), "0.1B")
        XCTAssertEqual(1238347410.abbrevation(), "1.2B")
        XCTAssertEqual(1258347410.abbrevation(), "1.3B")
        XCTAssertEqual(12543474100.abbrevation(), "12.5B")
        XCTAssertEqual(12583474100.abbrevation(), "12.6B")
    }
}

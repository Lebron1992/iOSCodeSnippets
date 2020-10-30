//
//  StringExtensionsTests.swift
//  iOSCodeSnippetsTests
//
//  Created by Lebron on 2020/10/30.
//  Copyright © 2020 Lebron. All rights reserved.
//

import XCTest
@testable import iOSCodeSnippets

class StringExtensionsTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func test_isEmail() {
        XCTAssertTrue("123@example.co".isEmail)
        XCTAssertTrue("123@example.com".isEmail)
        XCTAssertTrue("123@example.coma".isEmail)
        XCTAssertTrue("lebron.zeng@example.com".isEmail)
        XCTAssertTrue("lebron_zeng@example.com".isEmail)
        
        XCTAssertFalse("123@example.c".isEmail)
        XCTAssertFalse("@example.com".isEmail)
    }
    
    func test_trim() {
        var string = " string "
        XCTAssertEqual(string.trim(), "string")
        
        string = " string \n"
        XCTAssertEqual(string.trim(), "string")
        
        string = "string\n"
        XCTAssertEqual(string.trim(), "string")
    }

    func test_isEmpty() {
        var string: String?
        XCTAssertTrue(string.isEmpty)
        
        string = ""
        XCTAssertTrue(string.isEmpty)
        
        string = " "
        XCTAssertFalse(string.isEmpty)
    }
}

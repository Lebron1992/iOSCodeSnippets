//
//  NSErrorExtensionsTests.swift
//  iOSCodeSnippetsTests
//
//  Created by Lebron on 2020/10/29.
//  Copyright © 2020 Lebron. All rights reserved.
//

import XCTest
@testable import iOSCodeSnippets

class NSErrorExtensionsTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testInt_givenInvoGetCorrectInfo() {
        // given
        let domain = "com.lebron.iOSCodeSnippetsTests"
        let code = 500
        let reason = "Server error"
        
        // when
        let error = NSError(domain: domain, code: code, reason: reason)

        // then
        XCTAssertEqual(domain, error.domain)
        XCTAssertEqual(code, error.code)
        XCTAssertEqual(reason, error.localizedDescription)
    }
}

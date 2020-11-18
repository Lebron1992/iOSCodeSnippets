//
//  OptionalExtensionsTests.swift
//  iOSCodeSnippetsTests
//
//  Created by Lebron on 2020/10/29.
//  Copyright © 2020 Lebron. All rights reserved.
//

import XCTest
@testable import iOSCodeSnippets

class OptionalExtensionsTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func test_isNil() {
        let nilValue: String? = nil
        XCTAssertTrue(nilValue.isNil)
    }
    
    func test_isSome() {
        let nilValue: String? = "string"
        XCTAssertTrue(nilValue.isSome)
    }
    
    func test_doIfSome_bodyGetCalled() {
        // given
        let s1: String? = "s1"
        var s2: String?
        
        // when
        s1.doIfSome { s2 = $0 }
        
        // then
        XCTAssertEqual(s1, s2)
    }
}

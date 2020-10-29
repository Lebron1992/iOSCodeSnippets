//
//  DictionaryExtensionsTests.swift
//  iOSCodeSnippetsTests
//
//  Created by 曾文志 on 2020/9/29.
//  Copyright © 2020 Lebron. All rights reserved.
//

import XCTest
@testable import iOSCodeSnippets

class DictionaryExtensionsTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testWithAllValuesFrom_addedAllGivenValuesToReceiver() {
        // given
        var dict1 = ["a": 1, "b": 2]
        let dict2 = ["c": 3, "d": 4]
        
        // when
        dict1 = dict1.withAllValuesFrom(dict2)
        
        // then
        XCTAssertEqual(dict1, ["a": 1, "b": 2, "c": 3, "d": 4])
    }
    
    func testWithAllValuesFrom_givenValuesOverrideReceiver() {
        // given
        var dict1 = ["a": 1, "b": 2]
        let dict2 = ["a": 3, "c": 4]
        
        // when
        dict1 = dict1.withAllValuesFrom(dict2)
        
        // then
        XCTAssertEqual(dict1, ["a": 3, "b": 2, "c": 4])
    }
}

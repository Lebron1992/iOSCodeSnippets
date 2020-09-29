//
//  AppleSignInManagerTests.swift
//  iOSCodeSnippetsTests
//
//  Created by 曾文志 on 2020/9/24.
//  Copyright © 2020 Lebron. All rights reserved.
//

import AuthenticationServices
import XCTest
@testable import iOSCodeSnippets

class AppleSignInManagerTests: XCTestCase {
    
    var mockProvider: MockAuthorizationAppleIDProvider!
    var window: UIWindow!
    
    override func setUp() {
        super.setUp()
        mockProvider = MockAuthorizationAppleIDProvider()
        window = UIWindow()
    }
    
    override func tearDown() {
        mockProvider = nil
        window = nil
        super.tearDown()
    }
    
    func expectResultWhenGivenCredentialState(
        result: AppleSignInResult,
        givenState: ASAuthorizationAppleIDProvider.CredentialState
    ) {
        // given
        let expected = expectation(description: "get \(result)")
        let manager = AppleSignInManager(appleIDProvider: mockProvider, window: window) { res in
            if result == result {
                expected.fulfill()
            }
        }
        
        // when
        manager.validateCredentialState(appleUserId: "")
        mockProvider.sendValidateState(state: givenState, error: nil)
        
        // then
        wait(for: [expected], timeout: 1)
    }
    
    func testValidateCredentialState_whenRevoked_getRevokedResult() {
        expectResultWhenGivenCredentialState(result: .revoked, givenState: .revoked)
    }
    
    func testValidateCredentialState_whenNotFound_getNotFoundResult() {
        expectResultWhenGivenCredentialState(result: .notFound, givenState: .notFound)
    }
    
    func testObserveAppleSignInState_whenReceivedRevokedNotification_getRevokedResult() {
        // given
        let expected = expectation(description: "get revoked")
        let manager = AppleSignInManager(appleIDProvider: mockProvider, window: window) { result in
            if result == .revoked {
                expected.fulfill()
            }
        }
        manager.observeAppleSignInState()
        
        // when
        NotificationCenter.default.post(Notification(name: ASAuthorizationAppleIDProvider.credentialRevokedNotification))
        
        // then
        wait(for: [expected], timeout: 1)
    }
}

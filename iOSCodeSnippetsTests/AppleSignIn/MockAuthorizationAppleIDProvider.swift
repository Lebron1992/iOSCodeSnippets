//
//  MockAuthorizationAppleIDProvider.swift
//  iOSCodeSnippetsTests
//
//  Created by 曾文志 on 2020/9/24.
//  Copyright © 2020 Lebron. All rights reserved.
//

import AuthenticationServices
import Foundation
@testable import iOSCodeSnippets

@available(iOS 13, *)
final class MockAuthorizationAppleIDProvider: AuthorizationAppleIDProvider {
    
    private var validateStateBlock: ((ASAuthorizationAppleIDProvider.CredentialState, Error?) -> Void)?
    
    func createRequest() -> ASAuthorizationAppleIDRequest {
        ASAuthorizationAppleIDProvider().createRequest()
    }
    
    func getCredentialState(
        forUserID userID: String,
        completion: @escaping (ASAuthorizationAppleIDProvider.CredentialState, Error?) -> Void
    ) {
        validateStateBlock = completion
    }
    
    // MARK: - Send Data
    
    func sendValidateState(state: ASAuthorizationAppleIDProvider.CredentialState, error: Error?) {
        validateStateBlock?(state, error)
    }
}

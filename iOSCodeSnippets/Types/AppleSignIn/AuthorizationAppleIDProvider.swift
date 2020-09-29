//
//  AuthorizationAppleIDProvider.swift
//  iOSCodeSnippets
//
//  Created by 曾文志 on 2020/9/24.
//  Copyright © 2020 Lebron. All rights reserved.
//

import AuthenticationServices
import Foundation

public protocol AuthorizationAppleIDProvider {
    
    func createRequest() -> ASAuthorizationAppleIDRequest
    
    func getCredentialState(
        forUserID userID: String,
        completion: @escaping (ASAuthorizationAppleIDProvider.CredentialState, Error?) -> Void
    )
}

extension ASAuthorizationAppleIDProvider: AuthorizationAppleIDProvider {
}

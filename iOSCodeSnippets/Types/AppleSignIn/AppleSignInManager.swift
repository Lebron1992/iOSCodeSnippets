import AuthenticationServices
import UIKit

private let kSignInWithAppleUserInfoFirstNameKey = "SignInWithAppleUserInfoFirstName"
private let kSignInWithAppleUserInfoLastNameKey = "SignInWithAppleUserInfoLastName"
private let kSignInWithAppleUserInfoEmailKey = "SignInWithAppleUserInfoEmail"

public struct AppleUserInfo: Equatable {
    let idToken: String
    let userId: String
    let firstName: String
    let lastName: String
    let email: String
}

public enum AppleSignInResult: Equatable {
    case authorized(AppleUserInfo)
    case revoked
    case notFound
    case cancel
    case unknown
    case failure(Error)
    
    public static func == (lhs: AppleSignInResult, rhs: AppleSignInResult) -> Bool {
        switch (lhs, rhs) {
        case let (authorized(lInfo), authorized(rInfo)): return lInfo == rInfo
        case (revoked, revoked): return true
        case (notFound, notFound): return true
        case (cancel, cancel): return true
        case (unknown, unknown): return true
        case let (failure(lError), failure(rError)):
            return (lError as NSError).code == (rError as NSError).code
        default: return false
        }
    }
}

@available(iOS 13, *)
public final class AppleSignInManager: NSObject {

    private let appleIDProvider: AuthorizationAppleIDProvider
    
    private var window: UIWindow
    private var completion: (AppleSignInResult) -> Void

    public init(
        appleIDProvider: AuthorizationAppleIDProvider = ASAuthorizationAppleIDProvider(),
        window: UIWindow,
        completion: @escaping (AppleSignInResult) -> Void
    ) {
        self.appleIDProvider = appleIDProvider
        self.window = window
        self.completion = completion
        super.init()
    }

    deinit {
        NotificationCenter.default.removeObserver(
            self,
            name: ASAuthorizationAppleIDProvider.credentialRevokedNotification,
            object: nil
        )
    }

    // MARK: - Public Methods

    public func validateCredentialState(appleUserId: String) {
        appleIDProvider.getCredentialState(forUserID: appleUserId) { [weak self] credentialState, _ in
            switch credentialState {
            case .revoked: self?.completion(.revoked)
            case .notFound: self?.completion(.notFound)
            default: break
            }
        }
    }

    public func observeAppleSignInState() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleCredentialRevokedNotification(noti:)),
            name: ASAuthorizationAppleIDProvider.credentialRevokedNotification,
            object: nil
        )
    }

    @objc public func handleAuthorizationAppleIDButtonPress() {
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]

        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
}

// MARK: - Private

@available(iOS 13, *)
extension AppleSignInManager {
    @objc private func handleCredentialRevokedNotification(noti: Notification) {
        completion(.revoked)
    }
}

// MARK: - ASAuthorizationControllerDelegate & ASAuthorizationControllerPresentationContextProviding

@available(iOS 13, *)
extension AppleSignInManager: ASAuthorizationControllerDelegate,
ASAuthorizationControllerPresentationContextProviding {

    public func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        window
    }

    public func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithAuthorization authorization: ASAuthorization
    ) {
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            let userId = appleIDCredential.user
            let userDefs = UserDefaults.standard

            // Because some info is missing starting from the second request,
            // we have to cache them.
            
            var firstName = appleIDCredential.fullName?.givenName
            if firstName == nil {
                firstName = userDefs.string(forKey: kSignInWithAppleUserInfoFirstNameKey)
            } else {
                userDefs.setValue(firstName, forKey: kSignInWithAppleUserInfoFirstNameKey)
            }

            var lastName = appleIDCredential.fullName?.familyName
            if lastName == nil {
                lastName = userDefs.string(forKey: kSignInWithAppleUserInfoLastNameKey)
            } else {
                userDefs.setValue(lastName, forKey: kSignInWithAppleUserInfoLastNameKey)
            }

            var email = appleIDCredential.email
            if email == nil {
                email = userDefs.string(forKey: kSignInWithAppleUserInfoEmailKey)
            } else {
                userDefs.setValue(email, forKey: kSignInWithAppleUserInfoEmailKey)
            }

            var idToken = ""
            if let data = appleIDCredential.identityToken {
                idToken = String(data: data, encoding: .utf8) ?? ""
            }

            let info = AppleUserInfo(
                idToken: idToken,
                userId: userId,
                firstName: firstName ?? "",
                lastName: lastName ?? "",
                email: email ?? ""
            )
            completion(.authorized(info))
        default:
            break
        }
    }

    public func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithError error: Error
    ) {
        let err = error as NSError
        switch err.code {
        case ASAuthorizationError.Code.canceled.rawValue: completion(.cancel)
        case ASAuthorizationError.Code.unknown.rawValue: completion(.unknown)
        default: completion(.failure(err))
        }
    }
}

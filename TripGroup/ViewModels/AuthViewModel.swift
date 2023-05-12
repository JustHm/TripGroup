//
//  AuthViewModel.swift
//  TripGroup
//
//  Created by 안정흠 on 2023/05/08.
//
import FirebaseCore
import FirebaseAuth
import GoogleSignIn
//Apple 로그인에 사용
import AuthenticationServices
import CryptoKit

@MainActor
final class AuthViewModel: NSObject, ObservableObject {
    @Published var signState: SignState = .none
    var currentUser: User? { get { Auth.auth().currentUser }}
    // Unhashed nonce.
    fileprivate var currentNonce: String?
    private var isDeleteAccount: Bool = false
    
    func googleSignIn(isDeleteAccount: Bool = false) async {
        self.isDeleteAccount = isDeleteAccount
        signState = .load
        //Firebase client 연결 설정
        guard let clientID = FirebaseApp.app()?.options.clientID else { return}
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        //구글 로그인 실행
        do {
            let viewController = try getCurrentViewController()
            let userAuthentication = try await GIDSignIn.sharedInstance.signIn(withPresenting: viewController)
            let user = userAuthentication.user
            guard let idToken = user.idToken else {
                throw AuthenticationError.tokenError(message: "ID Token missing")
            }
            let accessToken = user.accessToken
            let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString,
                                                           accessToken: accessToken.tokenString)
            if isDeleteAccount {
                try await currentUser?.delete()
                signState = .none
            } else {
                await signInFirebase(credential: credential)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    func appleSignIn(isDeleteAccount: Bool = false) {
        self.isDeleteAccount = isDeleteAccount
        signState = .load
        
        let nonce = randomNonceString()
        currentNonce = nonce
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
        
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            signState = .signOut
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func firebaseReauthenticate() async throws {
        switch currentUser?.providerData[0].providerID {
        case "apple.com": //OAuthCredential
            appleSignIn(isDeleteAccount: true)
        case "google.com": //AuthCredential
            await googleSignIn(isDeleteAccount: true)
        default:
            break
        }
    }
}
// MARK: Firebase 로그인 기능 components 구현부
extension AuthViewModel {
    private func getCurrentViewController() throws -> UIViewController {
        //소셜 로그인 화면 띄우기 위한 VC 설정
        //'windows' was deprecated in iOS 15.0: Use UIWindowScene.windows on a relevant window scene instead
        //Scene에 접근할 때 원래쓰던 UIWindowScene.windows 방식은 곧 Deprecated 된다.
        let scenes = UIApplication.shared.connectedScenes
        guard let windowScene = scenes.first as? UIWindowScene,
              let window = windowScene.windows.first,
              let viewController = window.rootViewController else { throw AuthenticationError.viewError }
        return viewController
    }
    
    private func signInFirebase(credential: AuthCredential) async {
        do {
            let _ = try await Auth.auth().signIn(with: credential)
            signState = .signIn
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        var randomBytes = [UInt8](repeating: 0, count: length)
        let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
        if errorCode != errSecSuccess {
            fatalError(
                "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
            )
        }
        
        let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        
        let nonce = randomBytes.map { byte in
            // Pick a random character from the set, wrapping around if needed.
            charset[Int(byte) % charset.count]
        }
        
        return String(nonce)
    }
    
    @available(iOS 13, *)
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
}

//MARK: Delegate
extension AuthViewModel: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        ASPresentationAnchor()
    }
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            if isDeleteAccount {
                authorizationControllerDeleteAccount(appleIDCredential: appleIDCredential)
            } else {
                authorizationControllerSignIn(appleIDCredential: appleIDCredential)
            }
        }
    }
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("DEBUG: \(error.localizedDescription)")
    }
    private func authorizationControllerSignIn(appleIDCredential: ASAuthorizationAppleIDCredential) {
        //Login Part
        guard let nonce = currentNonce else {
            fatalError("Invalid state: A login callback was received, but no login request was sent.")
        }
        guard let appleIDToken = appleIDCredential.identityToken else {
            print("Unable to fetch identity token")
            return
        }
        guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
            print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
            return
        }
        // Initialize a Firebase credential, including the user's full name.
        let credential = OAuthProvider.appleCredential(withIDToken: idTokenString,
                                                       rawNonce: nonce,
                                                       fullName: appleIDCredential.fullName)
        
        // Sign in with Firebase.
        Task {
           await signInFirebase(credential: credential)
        }
    }
    private func authorizationControllerDeleteAccount(appleIDCredential: ASAuthorizationAppleIDCredential) {
        //Delete Account Part
        guard let appleAuthCode = appleIDCredential.authorizationCode else {
            print("Unable to fetch authorization code")
            return
        }
        
        guard let authCodeString = String(data: appleAuthCode, encoding: .utf8) else {
            print("Unable to serialize auth code string from data: \(appleAuthCode.debugDescription)")
            return
        }
        
        Task {
            do {
                try await Auth.auth().revokeToken(withAuthorizationCode: authCodeString)
                try await currentUser?.delete()
                signState = .delete
            } catch {
                print(error.localizedDescription)
                signState = .none
            }
        }
    }
}

enum AuthenticationError: Error {
    case tokenError(message: String)
    case viewError
}

enum SignState {
    case signIn
    case signOut
    case load
    case delete
    case none
}

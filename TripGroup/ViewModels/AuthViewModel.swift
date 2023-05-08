//
//  AuthViewModel.swift
//  TripGroup
//
//  Created by 안정흠 on 2023/05/08.
//
import FirebaseCore
import FirebaseAuth
import GoogleSignIn
import GoogleSignInSwift
//Apple 로그인에 사용
import AuthenticationServices
import CryptoKit

@MainActor
final class AuthViewModel: NSObject, ObservableObject {
    @Published var signState: SignState = .none
    @Published var isAuthHasError: Bool = false
    private var currentUser: User?
    var currentError: Error?
    // Unhashed nonce.
    fileprivate var currentNonce: String?
    enum SignState {
        case signIn
        case signOut
        case none
    }
    
    override init() {
        super.init()
        if let user = Auth.auth().currentUser {
            currentUser = user
            signState = .signIn
        }
    }
    
    func googleSignIn() async {
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
            await signInFirebase(credential: credential)
        } catch {
            currentError = error
            isAuthHasError.toggle()
        }
    }
    
    @available(iOS 13, *)
    func appleSignIn() {
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
            UserDefaults.standard.set(false, forKey: "isLoggedIn")
            UserDefaults.standard.set("", forKey: "uid")
        } catch {
            currentError = error
            isAuthHasError.toggle()
        }
    }
    func deleteAccount() {
        let user = Auth.auth().currentUser
        user?.delete(completion: {[weak self] error in
            if let error {
                self?.currentError = error
                self?.isAuthHasError.toggle()
            } else {
                self?.signState = .none
            }
        })
        
    }
}
// MARK: Apple 로그인 AuthenticationServices 구현부
extension AuthViewModel: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return ASPresentationAnchor()
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
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
            Task { await signInFirebase(credential: credential) }
        }
    }
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
        currentError = error
        isAuthHasError.toggle()
        print("Sign in with Apple errored: \(error)")
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
            let result = try await Auth.auth().signIn(with: credential)
            
            let firebaseUser = result.user
            
            signState = .signIn
            
            UserDefaults.standard.set(true, forKey: "isLoggedIn")
            UserDefaults.standard.set(firebaseUser.uid, forKey: "uid")
        } catch {
            print(error.localizedDescription)
        }
    }
}

enum AuthenticationError: Error {
    case tokenError(message: String)
    case viewError
}

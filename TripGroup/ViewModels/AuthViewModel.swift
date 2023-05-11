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
    var currentUser: User? { get { Auth.auth().currentUser }}
    // Unhashed nonce.
    fileprivate var currentNonce: String?
    
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
            print(error.localizedDescription)
        }
    }
    
    func appleSignIn(authorization: ASAuthorization) async {
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
            await signInFirebase(credential: credential)
        }
    }

    
    
    func signOut() {
        do {
            try Auth.auth().signOut()
        } catch {
            print(error.localizedDescription)
        }
    }
    func deleteAccount(){
        let user = Auth.auth().currentUser
        user?.delete(completion: { error in
            if let error {
                print("DEBUG: DELETE ERROR\(error.localizedDescription)")
            }
        })
    }
    private func reAuthenticate(credential: AuthCredential) async throws{
        let user = Auth.auth().currentUser
        try await user?.reauthenticate(with: credential)
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
//            let firebaseUser = result.user
        } catch {
            print(error.localizedDescription)
        }
    }
}

enum AuthenticationError: Error {
    case tokenError(message: String)
    case viewError
}

////
////  FirebaseViewModel.swift
////  TripGroup
////
////  Created by 안정흠 on 2023/05/11.
////
//import Foundation
//import AuthenticationServices
//
//@MainActor
//final class FirebaseViewModel: ObservableObject {
//    @Published var signState: SignState = .none
//    private let authViewModel: AuthViewModel
//    private let storageViewModel: StorageViewModel
//
//    init() {
//        authViewModel = AuthViewModel()
//        storageViewModel = StorageViewModel()
//        guard let _ = authViewModel.currentUser else { return }
//        signState = .signIn
//    }
//}
//
//
////MARK: Storage 관리
//extension FirebaseViewModel {
//    private func uploadUserData() async {
//        guard let user = authViewModel.currentUser else { return }
//
//        let member = TripUser(name: user.displayName ?? "user", avatar_url: user.photoURL, groups: [])
//        do {
//            try await storageViewModel.addUserInfo(user: member, uid: user.uid)
//        } catch {
//            print(error.localizedDescription)
//        }
//        signState = .signIn
//    }
//
//    func addGroup(groupName: String) {
//        guard let userUID = authViewModel.currentUser?.uid else { return }
//        do {
//            try storageViewModel.addGroup(groupName: groupName, uid: userUID)
//        } catch {
//            print(error.localizedDescription)
//        }
//    }
//}
//
//
////MARK: Auth 관리
//extension FirebaseViewModel {
//
//    func signInWithApple(authorization: ASAuthorization) async {
//        await authViewModel.appleSignIn(authorization: authorization)
//        await uploadUserData()
//    }
//
//    func signInWithGoogle() async {
//        await authViewModel.googleSignIn()
//        await uploadUserData()
//    }
//
//    func usermanage(action: AuthManage) {
//        switch action {
//        case .signOut:
//            authViewModel.signOut()
//            signState = .signOut
//        case .deleteAccount:
//            authViewModel.deleteAccount()
//            signState = .none
//        }
//    }
//}
//
//enum AuthManage {
//    case signOut
//    case deleteAccount
//}
//
//
//
//
//
//
//
//

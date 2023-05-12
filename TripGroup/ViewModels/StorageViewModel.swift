//
//  StorageViewModel.swift
//  TripGroup
//
//  Created by 안정흠 on 2023/05/09.
//

import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseStorage
import FirebaseAuth

final class StorageViewModel: ObservableObject {
    private let firestore = Firestore.firestore()
    private let storage = Storage.storage()
    
    func addGroup(groupName: String, uid: String) throws {
        let data = TripGroup(name: groupName,
                             members: [
                                Member(uid: uid, name: "JustHm")
                             ])
        let ref = firestore.collection("Group")
        let documentRef = try ref.addDocument(from: data)
    }
    func addUserInfo() async throws {
        guard let user = Auth.auth().currentUser else { return }
        let tripUser = TripUser(name: user.displayName ?? "user",
                                avatar_url: user.photoURL,
                                groups: [])
        let ref = firestore.collection("Users").document(user.uid)
        let snapshot = try await ref.getDocument()
        //유저정보가 이미 DB에 있다면 return
        guard !snapshot.exists else { return }
        //유저정보가 DB에 없다면..
        try ref.setData(from: tripUser)
    }
    func deleteUserInfo() {
        guard let user = Auth.auth().currentUser else { return }
        let ref = firestore.collection("Users").document(user.uid)
        ref.delete { error in
            if let error {
                print("DEBUG DOCUMENT DELETE ERROR: \(error.localizedDescription)")
            }
        }
    }
    
}


enum DBName: String {
    case article
}

enum StorageError: Error {
    case none
    case downloadError
    case uploadError(message: String)
}

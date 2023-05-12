//
//  SettingsView.swift
//  TripGroup
//
//  Created by 안정흠 on 2023/05/09.
//

import SwiftUI
import FirebaseAuth

struct SettingsView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject private var storage: StorageViewModel
    
    @State private var isLogout: Bool = false
    @State private var isDeleteAccount: Bool = false
    var body: some View {
        List {
            Section {
                HStack(spacing: 16.0) {
                    Image("metamong")
                        .resizable()
                        .frame(width: 64.0, height: 64.0)
                        .clipShape(Circle())
                        
                    Text(TripUser.userInfo?.name ?? "user")
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    Button {
                        print("Edit")
                    } label: {
                        Text("Edit")
                    }
                }
            }
            Section {
                Text("Group Manage")
                HStack {
                    Text("Erase Cache")
                    Spacer()
                    Text("100GB")
                        .foregroundColor(.secondary)
                }
                .onTapGesture {
                    print("Clear Cache")
                }
                Label("Help", systemImage: "questionmark.circle")
                    .foregroundColor(.primary)
            }
            Section {
                Button(action: {isLogout.toggle()}, label: {
                    Label("LogOut", systemImage: "door.left.hand.open")
                        .foregroundColor(.primary)
                })
                Button(action: {isDeleteAccount.toggle()} , label: {
                    Label("Delete Account", systemImage: "x.square")
                        .foregroundColor(.red)
                })
                    
            }
        }
        .listStyle(.insetGrouped)
        .alert("LogOut", isPresented: $isLogout) {
            Button("Logout", role: .destructive) {
                authViewModel.signOut()
            }
        } message: {
            Text("Are You Sure?")
        }
        .alert("Delete Account", isPresented: $isDeleteAccount) {
            Button("Delete", role: .destructive) {
                Task {
                    guard let user = authViewModel.currentUser else { return }
                    try await authViewModel.firebaseReauthenticate()
                    storage.deleteUserInfo(uid: user.uid)
                }
            }
        } message: {
            Text("You may re-Authenticate for Delete Account")
        }

    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(AuthViewModel())
    }
}

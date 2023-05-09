//
//  SettingsView.swift
//  TripGroup
//
//  Created by 안정흠 on 2023/05/09.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    var body: some View {
        List {
            Section {
                HStack(spacing: 16.0) {
                    Image("metamong")
                        .resizable()
                        .frame(width: 64.0, height: 64.0)
                        .clipShape(Circle())
                        
                    Text("UserName")
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
                Label("LogOut", systemImage: "door.left.hand.open")
                    .task { authViewModel.signOut() }
                    .foregroundColor(.primary)
                Label("Delete Account", systemImage: "x.square")
                    .task { authViewModel.deleteAccount() }
                    .foregroundColor(.red)
            }
        }
        .listStyle(.insetGrouped)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(AuthViewModel())
    }
}

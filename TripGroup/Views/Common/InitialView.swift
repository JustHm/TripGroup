//
//  InitialView.swift
//  TripGroup
//
//  Created by 안정흠 on 2023/05/08.
//

import SwiftUI

struct InitialView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject private var storage: StorageViewModel
    var body: some View {
        VStack {
            switch authViewModel.signState {
            case .signIn:
                ContentView()
                    .onAppear {
                        Task {
                            try await storage.addUserInfo()
                            
                        }
                    }
            case .signOut, .delete, .none:
                SignInView()
                    .background(Color.tripBackground)
            case .load:
                LoadView()
            }
        }
        .onAppear {}
    }
}

struct InitialView_Previews: PreviewProvider {
    static var previews: some View {
        InitialView()
    }
}

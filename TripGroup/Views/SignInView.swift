//
//  SignInView.swift
//  TripGroup
//
//  Created by 안정흠 on 2023/05/08.
//

import SwiftUI

struct SignInView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    var body: some View {
        VStack {
            Button("Google-SignIn") {
                Task { await authViewModel.googleSignIn() }
            }
            Button("Apple-SignIn") {
                Task { authViewModel.appleSignIn() }
            }
        }
        .padding()
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}

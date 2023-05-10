//
//  InitialView.swift
//  TripGroup
//
//  Created by 안정흠 on 2023/05/08.
//

import SwiftUI

struct InitialView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    var body: some View {
        VStack {
            switch authViewModel.signState {
            case .signIn:
                ContentView()
            case .signOut, .none:
                SignInView()
                    .background(Color.tripBackground)
            }
        }
        .onAppear {
            authViewModel.restoreSignIn()
        }
    }
}

struct InitialView_Previews: PreviewProvider {
    static var previews: some View {
        InitialView().environmentObject(AuthViewModel())
    }
}

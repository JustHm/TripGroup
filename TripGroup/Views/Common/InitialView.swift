//
//  InitialView.swift
//  TripGroup
//
//  Created by 안정흠 on 2023/05/08.
//

import SwiftUI

struct InitialView: View {
    @EnvironmentObject var firebase: FirebaseViewModel
    var body: some View {
        VStack {
            switch firebase.signState {
            case .signIn:
                ContentView()
            case .signOut, .none:
                SignInView()
                    .background(Color.tripBackground)
            }
        }
        .onAppear {}
    }
}

struct InitialView_Previews: PreviewProvider {
    static var previews: some View {
        InitialView().environmentObject(FirebaseViewModel())
    }
}

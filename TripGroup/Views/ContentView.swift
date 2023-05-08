//
//  ContentView.swift
//  TripGroup
//
//  Created by 안정흠 on 2023/05/08.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    var body: some View {
        NavigationView {
            switch authViewModel.signState {
            case .signIn:
                HomeView()
            case .signOut, .none:
                SignInView()
                    .background(Color.tripBackground)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

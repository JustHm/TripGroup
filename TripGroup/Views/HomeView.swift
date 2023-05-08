//
//  HomeView.swift
//  TripGroup
//
//  Created by 안정흠 on 2023/05/08.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    var body: some View {
        Button("Sign Out", action: {})
            .task {
                authViewModel.signOut()
            }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(AuthViewModel())
    }
}

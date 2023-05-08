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
        VStack(spacing: 16.0) {
            Spacer()
            Text("Trip Group")
                .font(.largeTitle)
                .bold()
                .foregroundColor(.white)
            Image("road-trip-travel")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding(.bottom, 64.0)
            
            Button {
                Task { await authViewModel.googleSignIn() }
            } label: {
                Label("Google Sign In", image: "G_Logo")
                    .frame(maxWidth: .infinity)
            }
            .foregroundColor(Color.black)
            .buttonStyle(.borderedProminent)
            .tint(.white)
            
            Button {
                Task { authViewModel.appleSignIn() }
            } label: {
                Label("Apple Sign In", systemImage: "apple.logo")
                    .imageScale(.large)
                    .frame(maxWidth: .infinity)
            }
            .foregroundColor(Color.white)
            .buttonStyle(.borderedProminent)
            .tint(.black)
            Spacer()
        }
        .padding()
        
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
            .environmentObject(AuthViewModel())
            .background(Color.tripBackground)
    }
}

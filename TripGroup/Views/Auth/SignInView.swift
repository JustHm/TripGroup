//
//  SignInView.swift
//  TripGroup
//
//  Created by 안정흠 on 2023/05/08.
//

import SwiftUI
import Lottie

struct SignInView: View {
    @EnvironmentObject private var authViewModel: AuthViewModel
    var body: some View {
        VStack(spacing: 16.0) {
            Spacer()
            Text("Trip Group")
                .font(.largeTitle)
                .bold()
                .foregroundColor(.white)
            
            LottieView(name: "car-ignite-animation", mode: .loop)

//            Button(action: {
//                Task {
//                    authViewModel.appleSignIn()
//                }
//            }, label: {
//                Label("Sign in with Apple", systemImage: "apple.logo")
//                    .frame(maxWidth: .infinity)
//            })
//            .frame(maxWidth: .infinity, maxHeight: 44.0)
            Button {
                Task {
                    await authViewModel.googleSignIn()
                }
            } label: {
                Label("Sign in with Google", image: "G_Logo")
                    .frame(maxWidth: .infinity)
            }
            .frame(maxHeight: 44.0)
            .foregroundColor(Color.black)
            .buttonStyle(.borderedProminent)
            .tint(.white)
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

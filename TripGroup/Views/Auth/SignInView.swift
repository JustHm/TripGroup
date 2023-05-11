//
//  SignInView.swift
//  TripGroup
//
//  Created by 안정흠 on 2023/05/08.
//

import SwiftUI
import Lottie
import _AuthenticationServices_SwiftUI
import GoogleSignInSwift

struct SignInView: View {
    @EnvironmentObject private var firebase: FirebaseViewModel
    var body: some View {
        VStack(spacing: 16.0) {
            Spacer()
            Text("Trip Group")
                .font(.largeTitle)
                .bold()
                .foregroundColor(.white)
            
            LottieView(name: "car-ignite-animation", mode: .loop)

            SignInWithAppleButton(
                onRequest: { request in
                    request.requestedScopes = [.fullName, .email]
                },
                onCompletion: { result in
                    switch result {
                    case .success(let authResults):
                        Task {
                            await firebase.signInWithApple(authorization: authResults)
                        }
                    case .failure(let error):
                        print(error.localizedDescription)
                        print("error")
                    }
                }
            ).frame(maxWidth: .infinity, maxHeight: 50.0)
            Button {
                Task {await firebase.signInWithGoogle() }
            } label: {
                Label("Sign in with Google", image: "G_Logo")
                    .frame(maxWidth: .infinity)
            }
            .foregroundColor(Color.black)
            .buttonStyle(.borderedProminent)
            .tint(.white)
            
//            Button {
//                Task { await firebase.signIn(provider:.apple) }
//            } label: {
//                Label("Apple Sign In", systemImage: "apple.logo")
//                    .imageScale(.large)
//                    .frame(maxWidth: .infinity)
//            }
//            .foregroundColor(Color.white)
//            .buttonStyle(.borderedProminent)
//            .tint(.black)
            Spacer()
        }
        .padding()
        
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
            .environmentObject(FirebaseViewModel())
            .background(Color.tripBackground)
    }
}

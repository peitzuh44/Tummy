//
//  SignInView.swift
//  Tummy
//
//  Created by Pei-Tzu Huang on 2024/9/1.
//

import SwiftUI
import AuthenticationServices

struct SignInView: View {
@ObservedObject var authManager: AuthManager
    var body: some View {
        VStack {
            Spacer()
            Image("Tummy")
                .resizable()
                .scaledToFit()
                .frame(width: 200)
                .clipShape(RoundedRectangle(cornerRadius: 20.0))
                .padding()
            VStack {
                SignInWithAppleButton(
                    onRequest: { request in
                        authManager.prepareRequest(request)
                    },
                    onCompletion: { result in
                        switch result {
                        case .success(let authorization):
                            authManager.signInWithApple(authorization: authorization)
                        case .failure(let error):
                            print("Sign in with Apple failed: \(error.localizedDescription)")
                        }
                    }
                )
                .signInWithAppleButtonStyle(.black)
                .frame(width: 280, height: 60)
                
                Button {
                    authManager.signInAnonymously()
                } label: {
                    Text("Sign In Anonymously")
                        .foregroundStyle(Color.white)
                        .frame(width: 280, height: 60)
                        .background(
                            RoundedRectangle(cornerRadius: 8.0)
                                .fill(Color.orange)
                        )
                }
            }

            Spacer()
        }
        .padding()
    }
}


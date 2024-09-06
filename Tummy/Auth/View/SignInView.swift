//
//  SignInView.swift
//  Tummy
//
//  Created by Pei-Tzu Huang on 2024/9/1.
//

import SwiftUI
import AuthenticationServices

struct SignInView: View {
    let gradient = LinearGradient(colors: [.babyBlue, .babyPurple, .babyPink], startPoint: .topLeading, endPoint: .bottomTrailing)
@ObservedObject var authManager: AuthManager
    
    var body: some View {
        ZStack {
            gradient.ignoresSafeArea(.all)
            VStack {
                Spacer()
                Image("TummyTwo")
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
                }

                Spacer()
            }
            .padding()
        }
    }
}


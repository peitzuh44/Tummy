//
//  AuthView.swift
//  Tummy
//
//  Created by Pei-Tzu Huang on 2024/9/1.
//

import SwiftUI

struct AuthView: View {
    @StateObject private var authManager = AuthManager()

    var body: some View {
        switch authManager.authState {
        case .signedIn:
            MainView(authManager: authManager)
        case .signedOut:
            SignInView(authManager: authManager)
        }
    }
}

#Preview {
    AuthView()
}

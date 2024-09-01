//
//  SettingsView.swift
//  Tummy
//
//  Created by Pei-Tzu Huang on 2024/9/1.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var authManager: AuthManager
    
    var body: some View {
        VStack {
            Button(action: authManager.signOut) {
                Text("Sign Out")
                    .foregroundColor(.red)
            }
            .padding()
            
            Button(action: authManager.deleteAccount) {
                Text("Delete Account")
                    .foregroundColor(.red)
            }
        }
        .padding()
    }
    
}



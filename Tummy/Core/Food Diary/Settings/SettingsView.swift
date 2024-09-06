//
//  SettingsView.swift
//  Tummy
//
//  Created by Pei-Tzu Huang on 2024/9/1.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var authManager: AuthManager
    @ObservedObject var storeViewModel: StoreViewModel
    @State private var showSubscriptionView: Bool = false
    @State private var showDeleteAccountAlert: Bool = false
    
    var body: some View {
        List {
            // Account
            Section {
                Button(action: authManager.signOut) {
                    Text("Sign Out")
                }
                Button(action:
                        {showDeleteAccountAlert = true
                }) {
                    Text("Delete Account")
                        .foregroundColor(.red)
                }
            } header: {
                HStack {
                    Image(systemName: "person")
                    Text("Account")
                }
            }
            
            // Upgrade
            Section {
                Button {
                    showSubscriptionView = true
                } label: {
                    HStack {
                        Image(systemName: "crown.fill")
                            .foregroundStyle(.yellow)
                        Text("Upgrade to Super Tummy")
                    }
                }

            } header: {
                HStack {
                    Image(systemName: "crown")
                    Text("Subscription")
                }
            }
        }
        .navigationTitle("Settings")
        
        // MARK: Sheets and alert
        .fullScreenCover(isPresented: $showSubscriptionView, content: {
            SubscriptionView(storeVM: storeViewModel)
        })
        
        .alert(isPresented: $showDeleteAccountAlert, content: {
            Alert(title: Text("Are you sure you want to delete your account? This action can't be undone"), primaryButton: .destructive(Text("Delete"), action: {
                authManager.deleteAccount()
            }), secondaryButton: .cancel())
        })
    }
    
}




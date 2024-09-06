//
//  HomeView.swift
//  Tummy
//
//  Created by Pei-Tzu Huang on 2024/9/5.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var authManager: AuthManager
    @ObservedObject var storeViewModel: StoreViewModel
    var body: some View {
        NavigationStack {
            VStack {
                // Tummy
                Image("TummyTwo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 180, height: 180)
                
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink {
                        SettingsView(authManager: authManager, storeViewModel: storeViewModel)
                    } label: {
                        Image(systemName: "gear")
                    }
                }
            }
        }
    }
}


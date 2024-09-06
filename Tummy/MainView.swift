//
//  MainView.swift
//  Tummy
//
//  Created by Pei-Tzu Huang on 2024/8/12.
//

import SwiftUI

struct MainView: View {
    @ObservedObject var authManager: AuthManager
    @State private var selectedTab: Int = 0 // Track the selected tab
    @StateObject var storeViewModel: StoreViewModel = StoreViewModel()
    var body: some View {
        VStack {
            TabView(selection: $selectedTab) { // Bind the selection
//                HomeView(authManager: authManager, storeViewModel: storeViewModel)
//                    .tabItem {
//                        Image(systemName: "house")
//                        Text("Home")
//                    }
//                    .tag(0) // Assign tag for selection
                
                FoodDiaryView(authManager: authManager)
                    .tabItem {
                        Image(systemName: "book.closed")
                        Text("Food Diary")
                    }
                    .tag(0) // Assign tag for selection
            }
            .onChange(of: selectedTab) {
                // Trigger haptic feedback when tab changes
                HapticManager.instance.impact(style: .medium)
            }
        }
    }
}

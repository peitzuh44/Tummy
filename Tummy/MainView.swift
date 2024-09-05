//
//  MainView.swift
//  Tummy
//
//  Created by Pei-Tzu Huang on 2024/8/12.
//

import SwiftUI

struct MainView: View {
    @ObservedObject var authManager: AuthManager
    var body: some View {
        VStack {
            TabView {
                FoodDiaryView(authManager: authManager)
                    .tabItem {
                        Image(systemName: "book.closed")
                        Text("Food Diary")
                    }
            }
        }
    }
}

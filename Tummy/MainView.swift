//
//  MainView.swift
//  Tummy
//
//  Created by Pei-Tzu Huang on 2024/8/12.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Image(systemName: "heart")
                    Text("Food")
                }
            FoodJournalView()
                .tabItem {
                    Image(systemName: "heart")
                    Text("Food")
                }
        }
    }
}

#Preview {
    MainView()
}

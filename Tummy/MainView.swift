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
            HomePage()
                .tabItem {
                    Image(systemName: "heart")
                    Text("Food")
                }
            FoodDiaryView()
                .tabItem {
                    Image(systemName: "book.closed")
                    Text("Food Diary")
                }
        }
    }
}

#Preview {
    MainView()
}

//
//  HomeView.swift
//  Tummy
//
//  Created by Pei-Tzu Huang on 2024/8/12.
//

import SwiftUI

struct HomeView: View {
    
    @StateObject var vm: FoodJournalViewModel = FoodJournalViewModel()
    
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    // Tummy
                    Image("Tummy")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                        .padding()
                    
                    // Navigate to before meal screen
                    NavigationLink {
                        BeforeMealSheet()
                    } label: {
                        HStack {
                            Text("Start Eating")
                                .foregroundStyle(Color.white)
                            
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 80)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(
                                    Color.blue.opacity(0.8)
                                )
                        )
                    }
               

                    
                }
            }
            .scrollIndicators(.hidden)
            .padding(.horizontal)
         
        }
    }
}

#Preview {
    HomeView()
}

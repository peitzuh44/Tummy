//
//  EntryDetailView.swift
//  Tummy
//
//  Created by Pei-Tzu Huang on 2024/8/31.
//

import SwiftUI

struct EntryDetailView: View {
    
    @StateObject var viewModel: FoodEntryViewModel
    var entry: FoodEntry
    @State private var showPostMealSheet = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading){
                
                // Food Photo
                Image("Food")
                    .resizable()
                    .frame(height: 500)
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
                    .clipShape(
                        Rectangle()
                    )
                
                // MARK: Complete post meal button
                if entry.postCompleted == false {
                    Button {
                        showPostMealSheet = true
                    } label: {
                        Text("post meal questionnarie")
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 60)
                            .background(
                                RoundedRectangle(cornerRadius: 20.0)
                                    .fill(Color.accentColor)
                            )
                            .padding()
                    }
                }
            
                // Info
                VStack(alignment: .leading){
                    HStack {
                        VStack (alignment: .leading){
                            VStack(alignment: .leading){
                                Text("Pei's breakfast")
                                    .font(.title2)
                                Text("August 30, 2024 12:34pm")
                                    .font(.caption)
                                Text("School | Ryan Ma | Social")
                                    .font(.caption)
                            }
                            .padding(.bottom)
                            
                            // Notes
                            VStack (alignment: .leading){
                                Text("Notes")
                                Text("I really enjoy the food.")
                            }
                            
                            VStack {
                                
                            }
                            .frame(height: 70)
                            
                        }
                      
                        Spacer()
                    }
                    .padding()
                    
                }
                .frame(maxWidth: .infinity)
            }
        }
        .ignoresSafeArea(.container)
        .scrollIndicators(.never)
        
        .fullScreenCover(isPresented: $showPostMealSheet, content: {
            PostFoodCheckInView(viewModel: viewModel, selectedEntry: entry)
        })
        .onAppear {
            print("Entry \(entry.id) passed in")
        }
    }
}


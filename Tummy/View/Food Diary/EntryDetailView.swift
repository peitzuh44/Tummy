//
//  EntryDetailView.swift
//  Tummy
//
//  Created by Pei-Tzu Huang on 2024/8/31.
//

import SwiftUI

struct EntryDetailView: View {
    
    @ObservedObject var viewModel: FoodEntryViewModel
    var entry: FoodEntry
    @State private var showPostMealSheet = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading){
                
                // Food Photo
                
                if let image = viewModel.image(for: entry) {
                    Image(uiImage: image)
                        .resizable()
                        .frame(height: 500)
                        .scaledToFit()
                        .frame(maxWidth: .infinity)
                        .clipShape(
                            Rectangle()
                        )
                } else {
                    ProgressView()
                        .frame(height: 150)
                }
                
                
                // MARK: Complete post meal button
                if entry.postCompleted == false {
                    Button {
                        showPostMealSheet = true
                    } label: {
                        HStack {
                            Image(systemName: "list.clipboard")
                            Text("post meal questionnarie")
                        }
                        .font(.headline)
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
                                Text("\(entry.mealType)")
                                    .font(.title2)
                                Text(entry.time.formatted())
                                    .font(.caption)
                                Text("\(entry.people) | \(entry.location) | \(entry.reason)")
                                    .font(.caption)
                                Text("Hunger before meal \(entry.hungerBefore)")
                                if entry.postCompleted {
                                    Text("Fullness after meal \(entry.fullnessAfter)")
                                }

                            }
                            .padding(.bottom)
                            
                            // Notes
                            VStack (alignment: .leading){
                                Text("✏️ Notes")
                                Text("\(entry.notes)")
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
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    //
                } label: {
                    Text("Edit")
                }

            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    //
                } label: {
                    Text("Delete")
                        .foregroundStyle(Color.red)
                }

            }
        }
        .navigationBarTitleDisplayMode(.large)
        .fullScreenCover(isPresented: $showPostMealSheet, content: {
            PostFoodCheckInView(viewModel: viewModel, selectedEntry: entry)
        })
        .onAppear {
            print("Entry \(entry.id) passed in")
        }
        .task {
        await viewModel.loadImage(for: entry)
        }
    }
}


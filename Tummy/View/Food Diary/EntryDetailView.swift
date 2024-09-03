//
//  EntryDetailView.swift
//  Tummy
//
//  Created by Pei-Tzu Huang on 2024/8/31.
//

import SwiftUI
import FirebaseAuth

struct EntryDetailView: View {
    
    @ObservedObject var viewModel: FoodEntryViewModel
    var entry: FoodEntry
    @State private var showPostMealSheet = false
    
    var icon: String {
        switch entry.mealType.lowercased() {
        case "breakfast":
            return "sun.horizon"
        case "lunch":
            return "sun.max"
        case "dinner":
            return "moon.stars"
        case "snack":
            return "cup.and.saucer"
        default:
            return "questionmark.circle"
        }
    }
    
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
                    VStack (alignment: .leading){
                        VStack(alignment: .leading){
                            HStack {
                                Image(systemName: icon)
                                Text("Your \(entry.mealType)")
                                    .font(.title)
                                    .fontWeight(.semibold)
                            }
                            Text(entry.time.formatted())
                            // MARK: Context
                            Divider()
                            VStack (alignment: .leading, spacing: 12){
                                Text("Context")
                                    .font(.title3)
                                // People
                                if !entry.people.isEmpty {
                                    HStack {
                                        Text("People")
                                        ScrollView(.horizontal){
                                            HStack {
                                                ForEach(entry.people, id: \.self) { tag in
                                                    ContextStringTag(text: tag ?? "You ate alone.")
                                                }
                                            }
                                        }
                                        .scrollIndicators(.hidden)
                                    }
                                } else {
                                    Text("You ate alone")
                                }
                                // Location
                                HStack {
                                    Text("Place")
                                    ScrollView(.horizontal){
                                        HStack {
                                            ForEach(entry.location, id: \.self) { tag in
                                                ContextStringTag(text: tag)
                                            }
                                        }
                                    }
                                    .scrollIndicators(.hidden)
                                }
                                // Reason
                                HStack {
                                    Text("Reason")
                                    ScrollView(.horizontal){
                                        HStack {
                                            ForEach(entry.reason, id: \.self) { tag in
                                                ContextStringTag(text: tag)
                                            }
                                        }
                                    }
                                    .scrollIndicators(.hidden)
                                }
                            }
                            
                            Text("Hunger before meal \(entry.hungerBefore)")
                            
                            if entry.postCompleted {
                                Text("Fullness after meal \(entry.fullnessAfter)")
                            }
                            
                        }
                        .padding(.bottom)
                        Divider()
                        // Notes
                        VStack (alignment: .leading, spacing: 12){
                            Text("✏️ Notes")
                                .font(.title3)
                            Text("\(entry.notes)")
                        }
                        
                        VStack {
                            
                        }
                        .frame(height: 70)
                        
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


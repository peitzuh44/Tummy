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
    @State private var showDeleteAlert = false
    @Environment(\.dismiss) var dismiss // Add this to dismiss the view

    var body: some View {
        ScrollView {
            VStack(alignment: .leading){
                // MARK: Food Photo
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
                    PostMealQuestionnaireButton(showPostMealSheet: $showPostMealSheet)
                }
                // Info
                VStack (alignment: .leading){
                    VStack(alignment: .leading){
                        HStack {
                            Image(systemName: entry.mealTypeIcon)
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
                            if !entry.people.isEmpty {
                                ContextDisplay(entry: entry, keyPath: \.people, title: "People")
                            } else {
                                Text("You ate alone")
                            }
                            ContextDisplay(entry: entry, keyPath: \.location, title: "Place")
                            ContextDisplay(entry: entry, keyPath: \.reason, title: "Reason")
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
                    // Bottom space
                    VStack {}.frame(height: 70)
                }
                .padding()
                .frame(maxWidth: .infinity)
            }
        }
        .ignoresSafeArea(.all)
        .scrollIndicators(.never)
        // MARK: Nav Bar
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    // delete entry
                    showDeleteAlert = true
                } label: {
                    Text("Delete")
                        .foregroundStyle(Color.red)
                }

            }
         
        }
        .navigationBarTitleDisplayMode(.large)
        
        // MARK: Alerts
        .alert(isPresented: $showDeleteAlert) {
            Alert(
                title: Text("Delete Entry"),
                message: Text("Are you sure you want to delete this entry? This action cannot be undone."),
                primaryButton: .destructive(Text("Delete")) {
                    Task {
                        await viewModel.deleteEntry(entryID: entry.id)
                        dismiss() // Navigate back after deleting the entry
                    }
                },
                secondaryButton: .cancel()
            )
        }
        // MARK: Sheets
        .fullScreenCover(isPresented: $showPostMealSheet, content: {
            PostFoodCheckInView(viewModel: viewModel, selectedEntry: entry)
        })
        // MARK: Fetching & Concurrency
        .onAppear {
            print("Entry \(entry.id) passed in")
        }
        .task {
            await viewModel.loadImage(for: entry)
        }
    }
}


struct ContextDisplay<T: Hashable>: View {
    var entry: FoodEntry
    var keyPath: KeyPath<FoodEntry, [T]>
    var title: String
    var body: some View {
        HStack {
            Text(title)
            ScrollView(.horizontal) {
                HStack {
                    ForEach(entry[keyPath: keyPath], id: \.self) { tag in
                        ContextStringTag(text: unwrap(tag))
                    }
                }
            }
            .scrollIndicators(.hidden)
        }
    }
    
    // Helper function to unwrap optional values or return "Unknown" if nil
    private func unwrap(_ tag: T) -> String {
        if let tag = tag as? String {
            return tag
        } else if let tag = tag as? Optional<String> {
            return tag ?? "Unknown"
        } else {
            return String(describing: tag) // Handle other types generically
        }
    }
}

struct ActionMenu: View {
    
    @ObservedObject var viewModel: FoodEntryViewModel
    var entry: FoodEntry
    
    var body: some View {
        Menu {
            Button {
                //
            } label: {
                Text("Edit")
            }
            Button {
                Task {
                    await viewModel.deleteEntry(entryID: entry.id)
                }
            } label: {
                Text("Delete")
                    .foregroundStyle(Color.red)
            }
        } label: {
            Image(systemName: "ellipsis.circle")
        }

    }
}

struct PostMealQuestionnaireButton: View {
    
    @Binding var showPostMealSheet: Bool
    
    var body: some View {
        Button {
            showPostMealSheet = true
        } label: {
            HStack {
                Image(systemName: "list.clipboard")
                Text("post meal questionnarie")
            }
            .foregroundStyle(Color.inverseText)
            .font(.headline)
            .frame(maxWidth: .infinity)
            .frame(height: 60)
            .background(
                RoundedRectangle(cornerRadius: 20.0)
                    .fill(Color.accentColor)
            )
            .padding()
        }
    }
}



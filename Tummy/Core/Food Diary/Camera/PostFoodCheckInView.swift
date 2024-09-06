//
//  PostFoodCheckInView.swift
//  Tummy
//
//  Created by Pei-Tzu Huang on 2024/8/16.
//

import SwiftUI

struct PostFoodCheckInView: View {
    
    @StateObject var viewModel: FoodEntryViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var selectedEntry: FoodEntry

    // selection - value to update
    @State var selectedFullness: HungerScaleOption = .five
    @State private var notes: String = ""
    // Show Sheets
    @State private var showHungerScale = false
    @State private var showNotePage = false
    

    var body: some View {
        // MARK: Fullness Scale
        NavigationStack {
            // MARK: Hunger Scale
            GenericPickerButton(pickerText: "Fullness", selectionText: selectedFullness.text, isPresenting: $showHungerScale) {
                HungerScale(selectedHunger: $selectedFullness)
            }

            
            // MARK: Notes
            Button {
                showNotePage = true
            } label: {
        
                if notes.isEmpty {
                    HStack {
                        Image(systemName: "square.and.pencil")
                        Text("Write some notes...")
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 60)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(.ultraThinMaterial)
                    )
                    .padding()
                } else {
                    HStack {
                        Text(notes)
                    }
                    .padding()
                    .frame(minWidth: 60)
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(.ultraThinMaterial)
                    )                    .padding()
                }
            }

            
            Spacer()
            
            // TODO: Update the food journal
            Button {
                presentationMode.wrappedValue.dismiss()
                Task {
                    print("get \(selectedEntry.id)")
                    try await viewModel.updatePostFoodInfo(entry: selectedEntry, fullness: selectedFullness, notes: notes)
                }
             
            } label: {
                Text("Complete Journal")
                    .foregroundStyle(Color.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .frame(height: 55)
                    .background(
                        RoundedRectangle(cornerRadius: 20.0)
                            .fill(Color.green)
                    )
                    .padding()
            }
            
            .navigationTitle("Post Food Check-In")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("X")
                            .foregroundStyle(Color.white)
                            .font(.title2)
                    }

                }
            }
        }
        .sheet(isPresented: $showNotePage) {
            AddNoteView(notes: $notes)
        }
        .onAppear {
            print("get entry \(selectedEntry.id)")
        }
    }
}

enum Mood: String, CaseIterable {
    case veryBad, bad, ok, good, veryGood
    
    var emoji: String {
        switch self {
        case .veryBad:
            return "verySad"
        case .bad:
            return "sad"
        case .ok:
            return "neutral"
        case .good:
            return "happy"
        case .veryGood:
            return "veryHappy"
        }
    }
}

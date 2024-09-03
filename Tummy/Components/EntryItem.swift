//
//  EntryItem.swift
//  Tummy
//
//  Created by Pei-Tzu Huang on 2024/8/31.
//

import SwiftUI

struct EntryItem: View {
    var entry: FoodEntry
    @ObservedObject var viewModel: FoodEntryViewModel
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
        NavigationLink {
            EntryDetailView(viewModel: viewModel, entry: entry)
        } label: {
            VStack {
                // Prompt
                if entry.postCompleted == false {
                    HStack {
                        Spacer()
                        Text("Post meal questionnaire >>")
                            .font(.caption)
                    }
                }
                VStack {
                    HStack (spacing: 16){
                        VStack {
                            if let image = viewModel.image(for: entry) {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFit()
                                    .clipShape(RoundedRectangle(cornerRadius: 10.0))
                                    .frame(height: 150)
                            } else {
                                ProgressView()
                                    .frame(height: 150)
                            }
                        }
                        VStack(alignment: .leading, spacing: 8){
                            HStack {
                                Image(systemName: "\(icon)")
                                Text(entry.mealType.capitalized)
                            }
                            .font(.headline)
                            Divider()
                            // Context tags
                            VStack(alignment: .leading, spacing: 8){
                                HStack {
                                    Text("People")
                                        .font(.caption)
                                    if !entry.people.isEmpty {
                                        ScrollView(.horizontal){
                                            HStack {
                                                ForEach(entry.people, id: \.self) { tag in
                                                    ContextStringTag(text: tag ?? "You ate alone.")
                                                }
                                            }
                                        }
                                        .scrollIndicators(.hidden)
                                    } else {
                                        Text("You ate alone")
                                    }
                                }
                                HStack {
                                    Text("Place")
                                        .font(.caption)
                                    ScrollView(.horizontal){
                                        HStack {
                                            ForEach(entry.location, id: \.self) { tag in
                                                ContextStringTag(text: tag)
                                            }
                                        }
                                    }
                                    .scrollIndicators(.hidden)
                                }
                                HStack {
                                    Text("Reason")
                                        .font(.caption)
                                    ScrollView(.horizontal){
                                        HStack {
                                            ForEach(entry.reason, id: \.self) { tag in
                                                ContextStringTag(text: tag)
                                            }
                                        }
                                    }
                                    .scrollIndicators(.hidden)
                                }
                                HStack {
                                    Text("Hungerness")
                                        .font(.caption)
                                    HStack {
                                        Text("\(entry.hungerBefore)")
                                        Image(systemName: "arrow.forward")
                                        Text("\(entry.fullnessAfter)")
                                        
                                    }
                                    .font(.caption2)
                                    .fontWeight(.medium)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 4)
                                    .background(
                                        RoundedRectangle(cornerRadius: 20.0)
                                            .fill(Color(.systemGray5))
                                    )
                                }
                            }
                        }
                    }
                    Divider()
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(viewModel.foodItems(for: entry)) { item in
                            HStack {
                                Text(item.name)
                                    .font(.headline)
                                Spacer()
                                Text("\(item.quantity) \(item.unit)")
                            }
                            
                        }
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 10.0)
                        .fill(.ultraThinMaterial)
                )
                HStack {
                    Spacer()
                    Text(entry.time.formatted())
                }
                .font(.caption2)
            }
        }
        .foregroundStyle(.white)
        .task {
            await viewModel.loadImage(for: entry)
            await viewModel.fetchFoodItems(for: entry) // Fetch food items

        }
        
        
    }
}


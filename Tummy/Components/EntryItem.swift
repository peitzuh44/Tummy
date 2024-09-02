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
    
    var body: some View {
        NavigationLink {
            EntryDetailView(viewModel: viewModel, entry: entry)
        } label: {
            VStack {
                // Prompt
                HStack {
                    Spacer()
                    Text("Post meal questionnaire >>")
                }
                .font(.caption)
                
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
                                Image(systemName: "sun.horizon")
                                Text("Breakfast")
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
                        HStack {
                            Text("🍜 Dry noodle")
                                .font(.headline)
                            Spacer()
                            Text("1 box")
                        }
                        
                        HStack {
                            Text("🍕 Hawaii Pizza")
                                .font(.headline)
                            Spacer()
                            Text("2 slices")
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
                    Text("Today 07:33pm")
                }
                .font(.caption2)
            }
        }
        .foregroundStyle(.white)
        .task {
            await viewModel.loadImage(for: entry)
        }
        
        
    }
}


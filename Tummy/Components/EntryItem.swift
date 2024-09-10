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
    @State private var isActive = false
    @State private var animateBlinking = false
    
    var body: some View {
        VStack {
            Button(action: {
                HapticManager.instance.impact(style: .medium) // Trigger haptic feedback
                isActive = true // Trigger navigation
            }) {
                VStack {
                    if entry.postCompleted == false {
                        HStack {
                            Spacer()
                            Text("Post meal questionnaire >>")
                                .font(.caption)
                                .opacity(animateBlinking ? 0.3 : 1.0)
                                .onAppear {
                                    
                                    withAnimation(Animation.easeInOut(duration: 0.7).repeatForever(autoreverses: true)) {
                                        animateBlinking.toggle()
                                    }
                                }
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
                                    Image(systemName: "\(entry.mealTypeIcon)")
                                    Text(entry.mealType.capitalized)
                                }
                                .font(.headline)
                                Divider()
                                VStack(alignment: .leading, spacing: 8){

                                    if !entry.people.isEmpty {
                                        ContextDisplay(entry: entry, keyPath: \.people, title: "People")
                                    } else {
                                        Text("You ate alone")
                                    }
                                    ContextDisplay(entry: entry, keyPath: \.location, title: "Place")

                                    ContextDisplay(entry: entry, keyPath: \.reason, title: "Reason")

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
            .navigationDestination(isPresented: $isActive) {
                EntryDetailView(viewModel: viewModel, entry: entry)
            }
        }
        .task {
            await viewModel.loadImage(for: entry)
            await viewModel.fetchFoodItems(for: entry) // Fetch food items
        }
    }
}

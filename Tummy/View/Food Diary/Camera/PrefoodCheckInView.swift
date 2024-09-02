//
//  PrefoodCheckInView.swift
//  Tummy
//
//  Created by Pei-Tzu Huang on 2024/8/16.
//

import SwiftUI

struct PrefoodCheckInView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var viewModel: FoodEntryViewModel
    @State private var newPerson: String = ""
    @State private var newPlace: String = ""
    @State private var newReason: String = ""
    @State private var selectedTags: [Tag] = []
    @State private var showHungerScale: Bool = false
    @State var selectedHunger: HungerScaleOption = .five
    @Binding var showMindfulEatingView: Bool
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack (spacing: 12){
                    // MARK: Meal Photo
                    Image("Breakfast")
                        .resizable()
                        .frame(width: 300, height: 300)
                        .clipShape(
                            RoundedRectangle(cornerRadius: 20)
                        )
                    
                    // MARK: Hunger Scale
                    GenericPickerButton(pickerText: "Hunger Scale", selectionText: selectedHunger.text, isPresenting: $showHungerScale) {
                        HungerScale(selectedHunger: $selectedHunger)
                    }
    

               
                    // Who are you eating with?
                    TaggingView(viewModel: viewModel, promptText: "Who are you eating with?", category: .people, newTagName: $newPerson, selectedTags: $selectedTags)
                        .background(
                            RoundedRectangle(cornerRadius: 20.0)
                                .fill(.thickMaterial)
                        )
                       
                    TaggingView(viewModel: viewModel, promptText: "Where are you eating?", category: .location, newTagName: $newPlace, selectedTags: $selectedTags)
                        .background(
                            RoundedRectangle(cornerRadius: 20.0)
                                .fill(.thickMaterial)
                        )
                        
                    // Where are you eating?
                    TaggingView(viewModel: viewModel, promptText: "Why are you eating?", category: .reason, newTagName: $newReason, selectedTags: $selectedTags)
                        .background(
                            RoundedRectangle(cornerRadius: 20.0)
                                .fill(.thickMaterial)
                        )
                    
                    // MARK: Next Button
                    Button {
                        Task {
                            await viewModel.createEntry(hungerBefore: selectedHunger)

                        }
                        presentationMode.wrappedValue.dismiss()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            showMindfulEatingView = true
                        }
                    } label: {
                            Text("Next")
                                .foregroundStyle(Color.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .frame(height: 55)
                                .background(
                                    RoundedRectangle(cornerRadius: 20.0)
                                        .fill(Color.blue)
                                )
                        }
                }
            }
            .scrollIndicators(.hidden)
            .padding(.horizontal)
            .navigationTitle("Prefood checkin")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                        Task {
                            await viewModel.resetTags()
                        }
                    } label: {
                        Text("X")
                            .foregroundStyle(Color.white)
                            .font(.title2)
                    }

                }
            }
        }
    }
}





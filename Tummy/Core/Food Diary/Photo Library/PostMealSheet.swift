//
//  PostMealSheet.swift
//  Tummy
//
//  Created by Pei-Tzu Huang on 2024/9/3.
//

import SwiftUI

struct PostMealSheet: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var viewModel: FoodEntryViewModel
    @State private var newPerson: String = ""
    @State private var newPlace: String = ""
    @State private var newReason: String = ""
    @State private var selectedTags: [Tag] = []
    @State private var showHungerScale: Bool = false
    @State private var showFullnessSelector: Bool = false
    @State var selectedHunger: HungerScaleOption = .five
    @State var selectedFullness: HungerScaleOption = .five
    @State private var foodItems: [FoodItem] = [] // Store the list of food items
    @State private var showAddFoodItemSheet = false
    @State private var selectedMeal: Meal = .breakfast
    @State private var notes: String = ""
    @State private var showNotePage = false
    


    var image: UIImage

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack (spacing: 16){
                    // MARK: Meal Photo
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
                    // MARK: Item description
                    VStack {
                        HStack {
                            Text("Food Items")
                            Spacer()
                            Button {
                                showAddFoodItemSheet = true
                            } label: {
                                Text("Add")
                            }

                        }
                        VStack {
                            ForEach(foodItems) { item in
                                HStack {
                                    Text(item.name)
                                    Spacer()
                                    Text("\(item.quantity) \(item.unit)")
                                }
                            }
                            .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                Button(role: .destructive) {
                                    // action here
                                } label: {
                                    Label("delete", systemImage: "trash.fill")
                                }

                            }
                        }
                    }
                    // MARK: Meal Picker
                    Picker("Meal", selection: $selectedMeal) {
                        ForEach(Meal.allCases, id: \.self) {
                            Text($0.text)
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding(.vertical, 8)
                    
                    
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
                            .foregroundStyle(.white)
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
                                    .foregroundStyle(.white)
                            }
                            .padding()
                            .frame(minWidth: 60)
                            .frame(maxWidth: .infinity)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(.ultraThinMaterial)
                            )                  
                        }
                    }
                    Spacer()

                    
                    // MARK: Next Button
                    Button {
                        print("FOOD ITEMS: \(foodItems)")
                        Task {
                            await viewModel.createPastEntry(hungerBefore: selectedHunger, image: image, meal: selectedMeal, foodItems: foodItems, fullnessAfter: selectedFullness, notes: notes)

                        }
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                            Text("Done")
                            .foregroundStyle(Color.theme.inverseText)
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
            .navigationTitle("Add Past Food")
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
                            .foregroundStyle(Color.theme.accent)
                            .font(.title2)
                    }

                }
            }
        }
        .sheet(isPresented: $showAddFoodItemSheet) {
            AddFoodItemSheet { newItem in
                foodItems.append(newItem)
            }
        }
        .sheet(isPresented: $showNotePage) {
            AddNoteView(notes: $notes)
        }
        .onAppear {
            print("get image: \(image)")
        }
    }
}




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
    @State private var selectedMeal: Meal = .breakfast
    @Binding var showMindfulEatingView: Bool
    @State private var foodItems: [FoodItem] = [] // Store the list of food items
    @State private var showAddFoodItemSheet = false
    
    // Photo
    var image: UIImage

    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack (spacing: 16){
                    // MARK: Meal Photo
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300, height: 300)
                    
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
                    
                    // MARK: Next Button
                    Button {
                        print("FOOD ITEMS: \(foodItems)")
                        Task {
                            await viewModel.createEntry(hungerBefore: selectedHunger, image: image, meal: selectedMeal, foodItems: foodItems)

                        }
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                            Text("Next")
                                .padding()
                                .frame(maxWidth: .infinity)
                                .frame(height: 55)
                                .foregroundStyle(Color.theme.inverseText)
                                .background(
                                    RoundedRectangle(cornerRadius: 20.0)
                                        .fill(Color.accentColor)
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
        .onAppear {
            print("get image: \(image)")
        }
    }
}


enum Meal: String, CaseIterable, Hashable {
    case breakfast, lunch, dinner, snack
    
    var text: String {
        switch self {
            
        case .breakfast:
            return "Breakfast"
        case .lunch:
            return "Lunch"
        case .dinner:
            return "Dinner"
        case .snack:
            return "Snack"
        }
    }
    
    var icon: String {
        switch self {
            
        case .breakfast:
            return "sun.horizon"
        case .lunch:
            return "sun.max.fill"
        case .dinner:
            return "moon.stars"
        case .snack:
            return "cup.and.saucer"
        }
    }
}

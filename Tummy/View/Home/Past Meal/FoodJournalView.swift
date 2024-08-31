//
//  FoodJournalView.swift
//  Tummy
//
//  Created by Pei-Tzu Huang on 2024/8/16.
//

import SwiftUI

struct FoodJournalView: View {
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            
        }
//        NavigationStack {
//            ScrollView {
//                VStack (spacing: 12){
//                    // MARK: Meal Photo
//                    Image("Breakfast")
//                        .resizable()
//                        .frame(width: 300, height: 300)
//                        .clipShape(
//                            RoundedRectangle(cornerRadius: 20)
//                        )
//                    
//                    // MARK: Hunger Scale
//                    GenericPickerButton(pickerText: "Hunger Scale", selectionText: selectedHunger.text, isPresenting: $showHungerScale) {
//                        HungerScale(selectedHunger: $selectedHunger)
//                    }
//    
//
//               
//                    // Who are you eating with?
//                    TaggingView(promptText: "Who were you eating with?", manager: manager, newTagName: $newPerson, category: .people)
//                        .background(
//                            RoundedRectangle(cornerRadius: 30.0)
//                                .fill(.thickMaterial)
//                        )
//                       
//                    TaggingView(promptText: "Where were you eating?", manager: manager, newTagName: $newPlace, category: .place)
//                        .background(
//                            RoundedRectangle(cornerRadius: 30.0)
//                                .fill(.thickMaterial)
//                        )
//                        
//                    // Where are you eating?
//                    TaggingView(promptText: "Why were you eating?", manager: manager, newTagName: $newWhyEat, category: .whyEat)
//                        .background(
//                            RoundedRectangle(cornerRadius: 30.0)
//                                .fill(.thickMaterial)
//                        )
//                    
//                    // MARK: Next Button
//                    Button {
//                        presentationMode.wrappedValue.dismiss()
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//                            showMindfulEatingView = true
//                        }
//                    } label: {
//                            Text("Next")
//                                .foregroundStyle(Color.white)
//                                .padding()
//                                .frame(maxWidth: .infinity)
//                                .frame(height: 55)
//                                .background(
//                                    RoundedRectangle(cornerRadius: 20.0)
//                                        .fill(Color.blue)
//                                )
//                        }
//
//
//
//                }
//            }
//            .scrollIndicators(.hidden)
//            .padding(.horizontal)
//            .navigationTitle("Prefood checkin")
//            .navigationBarTitleDisplayMode(.inline)
//            .toolbar {
//                ToolbarItem(placement: .topBarLeading) {
//                    Button {
//                        presentationMode.wrappedValue.dismiss()
//                    } label: {
//                        Text("X")
//                            .foregroundStyle(Color.white)
//                            .font(.title2)
//                    }
//
//                }
//            }
//        }
    }
}

#Preview {
    FoodJournalView()
}

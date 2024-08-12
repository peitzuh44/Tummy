//
//  FoodJournalView.swift
//  Tummy
//
//  Created by Pei-Tzu Huang on 2024/8/12.
//

import SwiftUI

struct FoodJournalView: View {
    
    @StateObject var vm: FoodJournalViewModel = FoodJournalViewModel()
    @State private var showFoodTemplateSheet: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack (alignment: .bottomTrailing){
                VStack {
                    headerView()
                    ScrollView {
                        VStack {
                            FoodJournalListSection(headerText: "Breakfast", vm: vm)
                            FoodJournalListSection(headerText: "Lunch", vm: vm)
                            FoodJournalListSection(headerText: "Dinner", vm: vm)
                            FoodJournalListSection(headerText: "Snack", vm: vm)
                            
                        }
                    }
                    .scrollIndicators(.hidden)
                }
                
                // Button
                FloatingActionButton(showSheet: $showFoodTemplateSheet)
                    .padding(.vertical)
            }
            .padding(.horizontal)
            // show sheet
            .fullScreenCover(isPresented: $showFoodTemplateSheet) {
                FoodTemplateSheet()
            }
        }
    }
    
    // MARK: Header View
    func headerView() -> some View {
        VStack (spacing: 12){
            HStack {
                Image(systemName: "heart.fill")
                    .foregroundStyle(Color.pink)
                Text("You just fed tummy 23 min ago.")
            }
            WeekCalendar()
        }
    }
}

#Preview {
    FoodJournalView()
}

struct FoodJournalListSection: View {
    
    @State var headerText: String
    @StateObject var vm: FoodJournalViewModel
    
    var body: some View {
        Section {
            VStack {
                VStack (alignment: .leading){
                    Text("Mood - Happy")
                    Text("Time spent eating: 15 min")
                    Text("Eating Alone")
                    Text("Fullness")
                }
                .hLeading()
                ForEach(vm.foodJournals, id: \.self) { journal in
                    HStack {
                        Text(journal)
                            .padding()
                        Spacer()
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 10.0)
                            .fill(Color.blue.opacity(0.3))
                    )
                }
            }
        } header: {
            HStack {
                Text(headerText)
                Spacer()
                Image(systemName: "plus")
            }
        }
    }
}


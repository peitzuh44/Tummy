//
//  BeforeMealSheet.swift
//  Tummy
//
//  Created by Pei-Tzu Huang on 2024/8/12.
//

import SwiftUI

struct BeforeMealSheet: View {
    
    @State private var showAddFoodSheet: Bool = false
    @State private var count: Int = 0
    
    var body: some View {
        NavigationStack {
            VStack {
                BeforeMealOne(count: $count, showSheet: $showAddFoodSheet)
            }
            .sheet(isPresented: $showAddFoodSheet) {
                FoodTemplateSheet()
            }
        }
        
    }
}

#Preview {
    BeforeMealSheet()
}

struct BeforeMealOne: View {
    @Binding var count: Int
    @Binding var showSheet: Bool
    var body: some View {
        VStack{
            Text("This is my...")
                .font(.title)
                .fontWeight(.semibold)
            VStack {
                HStack {
                    NavigationLink {
                        BeforeMealTwo(showSheet: $showSheet)
                    } label: {
                        Text("Breakfast")
                            .foregroundStyle(Color.white)
                            .frame(width: 150, height: 150)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.yellow.opacity(0.8))
                            )
                    }
                    NavigationLink {
                        BeforeMealTwo(showSheet: $showSheet)
                    } label: {
                        Text("Lunch")
                            .foregroundStyle(Color.white)
                            .frame(width: 150, height: 150)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.green.opacity(0.8))
                            )
                    }

                }
                HStack {
                    NavigationLink {
                        BeforeMealTwo(showSheet: $showSheet)
                    } label: {
                        Text("Snack")
                            .foregroundStyle(Color.white)
                            .frame(width: 150, height: 150)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.red.opacity(0.8))
                            )
                    }
                    NavigationLink {
                        BeforeMealTwo(showSheet: $showSheet)
                    } label: {
                        Text("Dinner")
                            .foregroundStyle(Color.white)
                            .frame(width: 150, height: 150)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.blue.opacity(0.8))
                            )
                    }
                    
                }
            }
        }
    }
}


struct BeforeMealTwo: View {
    
    @Binding var showSheet: Bool
    
    var body: some View {
        VStack{
            Spacer()
            Text("Hi Pei, What do you have for me?")
                .font(.title2)
                .fontWeight(.semibold)
            Image("Tummy")
                .resizable()
                .frame(width: 200, height: 200)
                .scaledToFit()
            Button {
                showSheet = true
            } label: {
                HStack {
                    Image(systemName: "plus.circle")
                    Text("Add food for Tummy")
                }
            }
            Spacer()
            
            NavigationLink {
                BeforeMealThree()
            } label: {
                Text("Next")
                    .foregroundStyle(Color.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 55)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.purple.opacity(0.8))
                    )
            }
            .padding()



        }
    }
}

struct BeforeMealThree: View {
    @StateObject var manager: MoodManager = MoodManager()
    @State private var searchTerm: String = ""
    
    var filteredMoods: [String] {
        guard !searchTerm.isEmpty else {
            return manager.moods
        }
        return manager.moods.filter {
            $0.localizedCaseInsensitiveContains(searchTerm)
        }
        
    }
    
    var body: some View {
        VStack {
            VStack{
                Text("How are you feeling?")
                    .font(.title2)
                    .fontWeight(.semibold)
                Image("Tummy")
                    .resizable()
                    .frame(width: 150, height: 150)
                    .scaledToFit()
                SearchBar(text: $searchTerm)
                
            }
            //ScrollView
            ScrollView (.vertical, showsIndicators: false){
                VStack {
                    ForEach(filteredMoods, id: \.self) {
                        mood in
                        HStack {
                            Text(mood)
                            Spacer()
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .frame(height: 55)
                        .background(
                            RoundedRectangle(cornerRadius: 10.0)
                                .fill(Color(.systemGray6))
                        )
                    }
                }
            }
            NavigationLink {
                EatingTimerVIew()
            } label: {
                Text("Start Eating")
                    .foregroundStyle(Color.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 55)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.purple.opacity(0.8))
                    )
            }
            .padding()
        }
    }
}

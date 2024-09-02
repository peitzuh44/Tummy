//
//  FoodDiaryView.swift
//  Tummy
//
//  Created by Pei-Tzu Huang on 2024/8/30.
//

import SwiftUI

// Date selector
struct FoodDiaryView: View {
    
    // View Model
    @ObservedObject var authManager: AuthManager
    @StateObject var viewModel: FoodEntryViewModel = FoodEntryViewModel()
    // Show sheets - Camera
    @State private var showCamera: Bool = false
    @State private var showPrefoodCheckIn: Bool = false
    @State private var showMindfulEatingView: Bool = false
    @State private var showPostEatingCheckIn: Bool = false
    @State private var selectedDate: Date = Date()
    @State private var addTapped: Bool = false
    @State private var rotation: CGFloat = 0
    var body: some View {
        NavigationStack {
            ZStack (alignment: .bottomTrailing){
                Color(.systemBackground).ignoresSafeArea(.all)
                VStack{
                    ScrollView {
                        VStack(spacing: 16){
                            ForEach(viewModel.foodEntries) { entry in
                                EntryItem(entry: entry, viewModel: viewModel)
                                  
                            }
                        }
                        .padding(.horizontal)
                    }
                    .scrollIndicators(.never)
                }
                
                Menu {
                    Button {
                        withAnimation {
                            addTapped.toggle()
                            showCamera = true
                        }
                    } label: {
                        Image(systemName: "camera")
                        Text("Camera")
                    }
                    Button {
                        withAnimation {
                            addTapped.toggle()
                        }
                    } label: {
                        Text("Past Meal")
                        
                        Image(systemName: "clock.arrow.circlepath")
                        
                        
                    }
                    
                } label: {
                    Image(systemName: "plus")
                        .font(.largeTitle)
                        .padding()
                        .foregroundStyle(.white)
                        .background(Circle()
                            .fill(Color.pink))
                    
                }
                .rotationEffect(
                    addTapped ? Angle(degrees: 45) : Angle(degrees: 0)
                )
                .onTapGesture {
                    withAnimation {
                        addTapped.toggle()
                    }
                }
                .padding()
                
                
                
            }
            // MARK: Sheets
            .fullScreenCover(isPresented: $showCamera, content: {
                PrefoodCheckInView(viewModel: viewModel, showMindfulEatingView: $showMindfulEatingView)
            })
            // Camera - mindful eating with Tummy
            .fullScreenCover(isPresented: $showMindfulEatingView, content: {
                MindfulEatingView(showPostFoodCheckIn: $showPostEatingCheckIn)
            })
           
            .toolbar {
                ToolbarItem (placement: .topBarTrailing){
                    NavigationLink {
                        SettingsView(authManager: authManager)
                    } label: {
                        Image(systemName: "gear")
                    }
                    
                }
                
            }
            .navigationTitle("Food Diary")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
            viewModel.fetchEntries(date: selectedDate)
        }
    }
}


// Post Components


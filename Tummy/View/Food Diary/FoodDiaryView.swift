//
//  FoodDiaryView.swift
//  Tummy
//
//  Created by Pei-Tzu Huang on 2024/8/30.
//

import SwiftUI
import PhotosUI


// Date selector
struct FoodDiaryView: View {
    
    // View Model
    @StateObject var authManager: AuthManager
    @StateObject var viewModel: FoodEntryViewModel = FoodEntryViewModel()
    // Show sheets - Camera
    @State private var showCamera: Bool = false
    @State private var showPrefoodCheckIn: Bool = false
    @State private var showMindfulEatingView: Bool = false
    @State private var showPostEatingCheckIn: Bool = false
    @State private var selectedDate: Date = Date()
    
    @State private var selectedImage: UIImage?
    @State private var showPicker = false
    @State private var showPastMealSheet = false

    
    // Camera setup
    @State private var image: UIImage?

    var body: some View {
        NavigationStack {
            ZStack (alignment: .bottomTrailing){
                Color(.systemBackground).ignoresSafeArea(.all)
                VStack(alignment: .center){
                    WeekCalendar(selectedDate: $selectedDate)
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
                        HapticManager.instance.impact(style: .light)
                        showCamera = true
                        
                    } label: {
                        Image(systemName: "camera")
                        Text("Camera")
                    }
                    Button {
                        HapticManager.instance.impact(style: .light)
                        showPicker = true
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
                .onTapGesture {
                    HapticManager.instance.impact(style: .light)

                }
                .padding()
                
                
            }
            // MARK: Camera
            .sheet(isPresented: $showCamera) {
                CameraView(image: $image, showPrefoodCheckIn: $showPrefoodCheckIn)
            }
            .fullScreenCover(isPresented: $showPrefoodCheckIn) {
                PrefoodCheckInView(viewModel: viewModel, showMindfulEatingView: $showMindfulEatingView, image: image ?? UIImage())
            }

            // Camera - mindful eating with Tummy
            .fullScreenCover(isPresented: $showMindfulEatingView, content: {
                MindfulEatingView(showPostFoodCheckIn: $showPostEatingCheckIn)
            })
            
            // Photo picker
            .fullScreenCover(isPresented: $showPicker) {
                            PhotoPicker(selectedImage: $selectedImage)
                    }
            
            .fullScreenCover(isPresented: $showPastMealSheet) {
                        if let selectedImage = selectedImage {
                            PostMealSheet(viewModel: viewModel, image: selectedImage)
                        }
                    }
            
           
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
        .onChange(of: selectedDate) { newValue in
            viewModel.fetchEntries(date: selectedDate)
        }
        .onChange(of: selectedImage) { newValue in
                       if newValue != nil {
                           showPastMealSheet = true
                       }
                   }
    }
}


// Post Components

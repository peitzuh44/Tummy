//
//  FoodDiaryView.swift
//  Tummy
//
//  Created by Pei-Tzu Huang on 2024/8/30.
//

import SwiftUI
import PhotosUI

struct FoodDiaryView: View {

    // View Models
     @ObservedObject var authManager: AuthManager // Passed from the parent view
     @StateObject var storeViewModel = StoreViewModel() // Initialize directly here
     @StateObject var viewModel: FoodEntryViewModel // Delay initialization
     
     // Custom initializer to handle the dependencies
     init(authManager: AuthManager) {
         _authManager = ObservedObject(wrappedValue: authManager)
         // Initialize `viewModel` after `storeViewModel` has been initialized
         _viewModel = StateObject(wrappedValue: FoodEntryViewModel(storeViewModel: StoreViewModel()))
     }
    @State private var selectedDate: Date = Date()
    
    // Show sheets - Camera
    @State private var showCamera: Bool = false
    @State private var showPrefoodCheckIn: Bool = false
    @State private var showMindfulEatingView: Bool = false
    @State private var showPostEatingCheckIn: Bool = false
    @State private var image: UIImage?  // Camera setup
    
    // Show sheets - pick from photo library
    @State private var selectedImage: UIImage?
    @State private var showPicker = false
    @State private var showPastMealSheet = false
    
    var body: some View {
        NavigationStack {
            ZStack (alignment: .bottomTrailing){
                Color(.systemBackground).ignoresSafeArea(.all)
           
                VStack(alignment: .center){
                    WeekCalendar(selectedDate: $selectedDate)
                    if viewModel.foodEntries.isEmpty {
                        VStack {
                            Spacer()
                            VStack (alignment: .center){
                                Image("TummyTwo")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 159, height: 150)
                                Text("This is an empty Tummy.")
                            }
                            Spacer()
                        }
                    } else {
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
                }
        
                // Add button
                AddFoodEntryButton(showCamera: $showCamera, showPicker: $showPicker)
            }
            // MARK: Camera
            .fullScreenCover(isPresented: $showCamera) {
                CameraView(image: $image, showPrefoodCheckIn: $showPrefoodCheckIn)
            }
            .fullScreenCover(isPresented: $showPrefoodCheckIn) {
                PrefoodCheckInView(viewModel: viewModel, showMindfulEatingView: $showMindfulEatingView, image: image ?? UIImage())
            }
            .fullScreenCover(isPresented: $viewModel.showMindfulEatingView, content: {
                MindfulEatingView(showPostFoodCheckIn: $showPostEatingCheckIn)
            })
            // MARK: Photo Picker
            .fullScreenCover(isPresented: $showPicker) {
                PhotoPicker(selectedImage: $selectedImage)
            }
            .fullScreenCover(isPresented: $showPastMealSheet) {
                if let selectedImage = selectedImage {
                    PostMealSheet(viewModel: viewModel, image: selectedImage)
                }
            }
            .fullScreenCover(isPresented: $viewModel.showSubscriptionView) {
                       SubscriptionView(storeVM: storeViewModel)
                   }
            // MARK: NavBar
            .toolbar {
                ToolbarItem (placement: .topBarTrailing){
                    NavigationLink {
                        SettingsView(authManager: authManager, storeViewModel: storeViewModel)
                    } label: {
                        Image(systemName: "gear")
                    }
                    
                }
                
            }
            .navigationTitle("Food Diary")
            .navigationBarTitleDisplayMode(.inline)
        }
        // MARK: Fetching
        .onAppear {
            viewModel.fetchEntries(date: selectedDate)
        }
        .onChange(of: selectedDate) {
            viewModel.fetchEntries(date: selectedDate)
        }
        .onChange(of: selectedImage) { newValue, _ in
            if newValue != nil {
                showPastMealSheet = true
            }
        }
    }
}


// Post Components
struct AddFoodEntryButton: View {
    @Binding var showCamera: Bool
    @Binding var showPicker: Bool
    var body: some View {
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
        .padding()
        .onTapGesture {
            HapticManager.instance.impact(style: .light)
        }
    }
}

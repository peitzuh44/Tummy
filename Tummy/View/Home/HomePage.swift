//
//  HomePage.swift
//  Tummy
//
//  Created by Pei-Tzu Huang on 2024/8/14.
//

import SwiftUI

struct HomePage: View {
    
    // Show Sheets - Camera
    @State private var showCamera: Bool = false
    @State private var showPrefoodCheckIn: Bool = false
    @State private var showMindfulEatingView: Bool = false
    @State private var showPostEatingCheckIn: Bool = false
    
    // Show Sheets - Skip
    @State private var showSkip: Bool = false
    
    // Show Sheets - Past Meal
    @State private var showPastMeal: Bool = false
    
    
    // Animation
    @Namespace var namespace
    @State private var animate = false
    
    // IDEL
    @State private var isVisible = true
    @State private var showDetail = false
    @State private var showMindfulEatingSheet = false
    @State var show: Bool = false
    
    // UI
    let gradient = LinearGradient(colors: [Color.babyBlue, Color.babyPurple, Color.babyPink], startPoint: .bottomTrailing, endPoint: .topLeading)
    
    var body: some View {
        NavigationStack {
            ZStack {
                
                // MARK: Background
                Color(.systemBackground).ignoresSafeArea(.all)
                Ellipse()
                    .rotation(Angle(degrees: -90))
                    .fill(gradient)
                    .ignoresSafeArea(.all)
                    .offset(x:0, y: -280)
                // Background ENDS
                
                ScrollView {
                    if isVisible{
                        VStack (spacing: 16){
                            // MARK: Tummy and Status
                            HStack {
                                Image("Tummy")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 100, height: 100)
                                // Status
                                VStack (alignment: .leading){
                                    HStack (spacing: 4){
                                        Image(systemName: "heart.fill")
                                            .foregroundStyle(Color.pink)
                                            .font(.caption)
                                        Text("Last Fed - 23min")
                                            .fontWeight(.semibold)
                                    }
                                    HStack (spacing: 4){
                                        Image(systemName: "heart.fill")
                                            .foregroundStyle(Color.pink)
                                            .font(.caption)

                                        Text("Average feeding - 3hr20min")
                                            .fontWeight(.semibold)
                                    }
                
                                }
                            }
                            // Tummy and status ENDS
                            
                            // MARK: WeekCalendar
                            WeekCalendar()
                                .padding(.vertical)
                                .padding(.bottom)
                            // Body
                            MealItemActionState(showCamera: $showCamera, showSkip: $showSkip, showPastMeal: $showPastMeal)
                                .padding(.horizontal)

                            MealItemActionState(showCamera: $showCamera, showSkip: $showSkip, showPastMeal: $showPastMeal, icon: "sun.max", color: Color.green, meal: "Lunch")
                                .padding(.horizontal)
                            MealItemActionState(showCamera: $showCamera, showSkip: $showSkip, showPastMeal: $showPastMeal, icon: "moon.stars", color: Color.blue, meal: "Dinner")
                                .padding(.horizontal)

                            if showDetail {
                                
                            } else {
                                MealItem(animationID: "Breakfast")
                                    .padding(.horizontal)
                                    .onTapGesture {
                                        withAnimation {
                                            showDetail = true
                                            
                                        }
                                    }
                            }
                            
                            MealItem(meal: "Lunch", color: Color.green, icon: "sun.max")
                                .padding(.horizontal)
                            MealItem(meal: "Dinner", color: Color.blue, icon: "moon.stars")
                                .padding(.horizontal)
                            MealItem(meal: "Snack", color: Color.red, icon: "cup.and.saucer")
                                .padding(.horizontal)
                            MealItem(meal: "Snack", color: Color.red, icon: "cup.and.saucer")
                                .padding(.horizontal)
                            MealItem(meal: "Snack", color: Color.red, icon: "cup.and.saucer")
                                .padding(.horizontal)
                            
                        }
                        
                        // MARK: Animation
                        .opacity(animate ? 1 : 0)
                        .offset(y: animate ? 0 : 20)
                        .animation(.easeIn(duration: 0.5), value: animate)
                    }
                }
                .scrollIndicators(.hidden)
                
                if showDetail {
                    DetailPage(showDetail: $showDetail)
                    
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Image(systemName: "camera")
                }
            }
        }
        // MARK: Sheets
        
        // Skip - Why skip
        .fullScreenCover(isPresented: $showSkip, content: {
            WhySkipView()
        })
        
        // Camera - prefood checkin
        .fullScreenCover(isPresented: $showCamera, content: {
            PrefoodCheckInView(showMindfulEatingView: $showMindfulEatingView)
        })
        // Camera - mindful eating with Tummy
        .fullScreenCover(isPresented: $showMindfulEatingView, content: {
            MindfulEatingView(showPostFoodCheckIn: $showPostEatingCheckIn)
        })
        
        // Camera - post eating check-in
        .fullScreenCover(isPresented: $showPostEatingCheckIn, content: {
            PostFoodCheckInView()
        })
        // Past Meal
        .sheet(isPresented: $showPastMeal, content: {
            FoodJournalView()
        })
        
        // On View Load
        .onAppear {
               isVisible = true
               animate = false
                   
           DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
               animate = true
           }
       }
       .onDisappear {
           // Reset the visibility and animation state when the view disappears
           isVisible = false
           animate = false
       }
        }
}

#Preview {
    HomePage()
}



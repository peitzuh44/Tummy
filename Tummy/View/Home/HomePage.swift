//
//  HomePage.swift
//  Tummy
//
//  Created by Pei-Tzu Huang on 2024/8/14.
//

import SwiftUI

struct HomePage: View {
    
    @State private var animate = false
    @State private var isVisible = true
    @State private var showDetail = false
    @Namespace var namespace
    @State var show: Bool = false
    let gradient = LinearGradient(colors: [Color.babyBlue, Color.babyPurple, Color.babyPink], startPoint: .bottomTrailing, endPoint: .topLeading)
    
    var body: some View {
            ZStack {
                // MARK: Background
                Color(.systemBackground).ignoresSafeArea(.all)
                Ellipse()
                    .rotation(Angle(degrees: -90))
                    .fill(gradient)
                    .ignoresSafeArea(.all)
                    .offset(x:0, y: -260)
                ScrollView {
                    // MARK: Tummy
                if isVisible{
                    VStack (spacing: 16){
                        Image("Tummy")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 120, height: 120)
                        HStack {
                            Image(systemName: "heart.fill")
                                .foregroundStyle(Color.pink)
                            Text("You just fed Tummy 23 min ago")
                                .fontWeight(.semibold)
                        }
                        // MARK: WeekCalendar
                        WeekCalendar()
                            .padding(.vertical)
                            .padding(.bottom)
                        // Body
                        MealItemNotStarted()
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
                    .opacity(animate ? 1 : 0)
                    .offset(y: animate ? 0 : 20) // Start slightly lower
                    .animation(.easeIn(duration: 0.5), value: animate)
                }
            }
            .scrollIndicators(.hidden)
                if showDetail {
                    DetailPage(showDetail: $showDetail)
                        
                }
            }
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



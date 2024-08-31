//
//  MindfulEatingTimerView.swift
//  Tummy
//
//  Created by Pei-Tzu Huang on 2024/8/16.
//

import SwiftUI

struct MindfulEatingTimerView: View {
    @Environment(\.presentationMode) var presentationMode
    @State var setTime: Double = 25
    @State private var navigate = false
    @StateObject var timeManager: TimeManager = TimeManager()
    @Binding var showPostFoodCheckIn: Bool
    var body: some View {
        VStack {
            Spacer()
            ZStack (alignment: .center){
                ZStack {
                    // Background circle
                    Circle()
                        .stroke(lineWidth: 20.0)
                        .opacity(0.3)
                        .foregroundColor(Color.blue)
                    
                    // Foreground circle that fills up
                    Circle()
                        .trim(from: 0.0, to: CGFloat(1 - (timeManager.timeRemaining / timeManager.totalTime)))
                        .stroke(style: StrokeStyle(lineWidth: 10.0, lineCap: .round, lineJoin: .round))
                        .foregroundColor(Color.blue)
                        .rotationEffect(Angle(degrees: -90.0))  // Start filling from the top
                        .animation(.linear(duration: 1.0), value: timeManager.timeRemaining)
                }
                .frame(width: 300, height: 300)
                VStack (spacing: 0){
                    Image("Tummy")
                        .resizable()
                        .frame(width: 150, height: 150)
                        .scaledToFit()
                    Text(timeManager.timeString())
                        .font(.largeTitle)
                        .bold()
                }
              
            }
            Spacer()
            
            // Primary Button
            Button(action: {
                if timeManager.isRunning {
                    timeManager.stopCountdownTimer()
                    presentationMode.wrappedValue.dismiss()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        
                        showPostFoodCheckIn = true
                    }
                } else {
                    timeManager.startCountdownTimer()
                }
            }) {
                Text(timeManager.isRunning ? "I'm done with eating!" : "Mindful Eating With Tummy")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .frame(height: 55)
                    .background(timeManager.isRunning ? Color.red : Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
            if !timeManager.isRunning {
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Text("Skip")
                        .padding()
                
                }
            }

           
        }
    }
}


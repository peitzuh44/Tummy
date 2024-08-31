//
//  MindfulEatingWithTummyView.swift
//  Tummy
//
//  Created by Pei-Tzu Huang on 2024/8/17.
//

import SwiftUI
import Combine

//struct MindfulEatingWithTummyView: View {
//    @State private var timer = Timer.publish(every: 1.0, on: .main, in: .common)
//    let durations: [TimeInterval] = [10, 3, 5, 8, 4]
//    @State private var currentStep: Int = 0
//    @State private var cancellable: Cancellable? = nil
//    @State private var isRunning: Bool = false
//
//
//
//
//    var body: some View {
//        VStack {
//            if isRunning {
//                VStack {
//                    switch currentStep {
//                    
//                    case 0:
//                        Text("Eliminate Distraction")
//                            .font(.title)
//                        Image(systemName: "iphone.gen3.slash.circle")
//                            .resizable()
//                            .frame(width: 150, height: 150)
//                        Text("Put away your smart phone.")
//                        
//                    // MARK: Eyes
//                    case 1: // 1-1
//                       VStack (spacing: 30){
//                           Text("Take a look at the food")
//                               .font(.title)
//                           Image(systemName: "eyes")
//                               .resizable()
//                               .frame(width: 150, height: 150)
//                    }
//                    case 2: // 1-2
//                        VStack (spacing: 30){
//                            Text("Take a look at the food")
//                                .font(.title)
//                            Image(systemName: "eyes")
//                                .resizable()
//                                .frame(width: 150, height: 150)
//                            Text("What is it you are eating?")
//                     }
//                    case 3: // 1-3
//                        VStack (spacing: 30){
//                            Text("Take a look at the food")
//                                .font(.title)
//                            Image(systemName: "eyes")
//                                .resizable()
//                                .frame(width: 150, height: 150)
//                            Text("What is it you are eating?")
//                            Text("What color/shape is it?")
//                     }
//                    //MARK: Nose
//                        
//                    default:
//                        VStack {
//                            
//                        }
//                    }
//                }
//            }
//        }
//
//        
//
//        
//        // Nose
////        VStack (spacing: 30){
////            Text("Take a smell of the food")
////                .font(.title)
////            Image(systemName: "nose.fill")
////                .resizable()
////                .frame(width: 150, height: 150)
////            Text("How does it smell?")
////            Text("Is it a new food?")
////            Text("Have you smelled it before?")
////        }
//        
//        // Taste
////        VStack (spacing: 30){
////            Text("Now, taste the food")
////                .font(.title)
////            Image(systemName: "mouth")
////                .resizable()
////                .scaledToFit()
////                .frame(width: 150, height: 150)
////            Text("How does it taste?")
////            Text("How is the texture?")
////            Text("Does the flavor change as you continue to chew it ?")
////            Text("Does it taste different on different parts of your tongue?")
////        }
//        
//    }
//    
//}

#Preview {
    MindfulEatingWithTummyView()
}
import SwiftUI
import Combine

struct MindfulEatingWithTummyView: View {
    
    // Array of durations for each step in seconds
    let durations: [TimeInterval] = [5, 5, 5, 5, 5]
    
    @State private var currentStep: Int = 0
    @State private var isRunning: Bool = false
    @State private var timer: Timer.TimerPublisher = Timer.publish(every: 10.0, on: .main, in: .common)
    @State private var cancellable: Cancellable? = nil
    
    var body: some View {
        VStack {
            if isRunning {
                VStack {
                    switch currentStep {
                    case 0:
                    VStack {
                            
                    }
                        
                    // MARK: Eyes
                    case 1: // 1-1
                       VStack (spacing: 30){
                           VStack {
                               Text("Take a look at the food")
                                   .font(.title)
                               Image(systemName: "eyes")
                                   .resizable()
                                   .frame(width: 150, height: 150)
                           }
                           .frame(height: 200)
                           VStack {
                               
                           }
                           .frame(height: 100)

                    }
                    case 2: // 1-2
                        VStack (spacing: 30){
                            VStack {
                                Text("Take a look at the food")
                                    .font(.title)
                                Image(systemName: "eyes")
                                    .resizable()
                                    .frame(width: 150, height: 150)
                            }
                            .frame(height: 200)
                          
                            VStack {
                                Text("What is it you are eating?")
                            }
                            .frame(height: 100)

                     }
                    case 3: // 1-3
                        VStack (spacing: 30){
                            VStack {
                                Text("Take a look at the food")
                                    .font(.title)
                                Image(systemName: "eyes")
                                    .resizable()
                                    .frame(width: 150, height: 150)
                            }
                            .frame(height: 200)
                            VStack {
                                Text("What is it you are eating?")
                            }
                            .frame(height: 100)
                            VStack {
                                Text("What color/shape is it?")

                            }
                            .frame(height: 100)

                     }
                    //MARK: Nose
                        
                    default:
                        VStack {
                            
                        }
                    }
                }
                .onReceive(timer) { _ in
                    withAnimation(Animation.easeInOut(duration: 1.5)) {
                        moveToNextStep()
                    }
                    
                }
            } else {
                VStack {
                    Spacer()
                    Image("Tummy")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                    Spacer()
                    VStack (spacing: 30){
                        Button(action: startPractice) {
                            Text("Mindful Eating With Tummy")
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(20)
                        }
                        Button {
                            //skip
                        } label: {
                            Text("Skip")
                        }
                    }

                   
                }
                .padding()
               
            }
        }
    }
    
    private func startPractice() {
        currentStep = 0
        isRunning = true
        startTimer()
    }
    
    private func startTimer() {
        // Set the timer interval based on the current step's duration
        timer = Timer.publish(every: durations[currentStep], on: .main, in: .common)
        cancellable = timer.connect()  // No casting needed
    }
    
    private func moveToNextStep() {
        // Increment the step or finish
        if currentStep < durations.count - 1 {
            currentStep += 1
            cancellable?.cancel()
            startTimer()
        } else {
            isRunning = false
            cancellable?.cancel()
        }
    }
    
    private func restartPractice() {
        isRunning = false
    }
}


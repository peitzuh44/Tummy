//
//  MindfulEatingView.swift
//  Tummy
//
//  Created by Pei-Tzu Huang on 2024/8/17.
//


import SwiftUI

struct MindfulEatingView: View {
    @Binding var showPostFoodCheckIn: Bool
    
    @Environment(\.presentationMode) var presentationMode

    @State private var isPlaying = false
    @State private var showCompleteButton = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Spacer()
                VStack {
                    Image("Tummy")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                        .scaleEffect(isPlaying ? 1.1 : 1.0)
                        .animation(isPlaying ? Animation.easeInOut(duration: 1).repeatForever(autoreverses: true) : .default, value: isPlaying)
                }
                
                if isPlaying {
                    Spacer()
                    Button {
                        cancelMindfulEating()
                    } label: {
                        Text("Cancel")
                    }
                } else {
                    if !showCompleteButton {
                        Spacer()
                        Button(action: startMindfulEating) {
                            Text("Mindful Eating With Tummy")
                                .font(.headline)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(20)
                        }
                        Button {
                            presentationMode.wrappedValue.dismiss()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                showPostFoodCheckIn = true
                            }
                        } label: {
                            Text("Skip")
                                .padding()
                                .frame(maxWidth: .infinity)
                        }
                    }

                }

                if showCompleteButton {
                    Spacer()
                    Button {
                        presentationMode.wrappedValue.dismiss()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            showPostFoodCheckIn = true
                            stopMindfulEating()
                        }
                    } label: {
                        Text("Complete Mindful Eating")
                            .font(.headline)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
            }
            .padding()
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        cancelMindfulEating()
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("X")
                            .foregroundStyle(Color.white)
                            .font(.title2)
                    }

                }
            }
        }
    }
    
    func startMindfulEating() {
        SoundManager.shared.playSound(filename: "MindfulEating", fileType: "mp3")
        isPlaying = true
        SoundManager.shared.onFinishedPlaying = {
            stopMindfulEating()
            showCompleteButton = true
        }
    }
    
    func stopMindfulEating() {
        isPlaying = false
        SoundManager.shared.audioPlayer?.stop()
        SoundManager.shared.audioPlayer = nil
    }
    
    func cancelMindfulEating() {
        stopMindfulEating()
        showCompleteButton = false
        isPlaying = false
    }
        
}

#Preview {
    MindfulEatingView(showPostFoodCheckIn: .constant(true))
}



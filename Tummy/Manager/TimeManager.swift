//
//  TimeManager.swift
//  Tummy
//
//  Created by Pei-Tzu Huang on 2024/8/12.
//

import Foundation


class TimeManager: ObservableObject {
    
    @Published var countdownTimer: Timer? = nil
    @Published var isRunning: Bool = false
    @Published var timeRemaining: Double = 0
    @Published var totalTime: Double = 0
    
    init() {
        self.setTime = 25
        self.timeRemaining = setTime * 60 // Initialize timeRemaining based on setTime
        self.totalTime = setTime * 60
    }
    
    @Published var setTime: Double
    
    // start countdown
    func startCountdownTimer() {
        isRunning = true
        countdownTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if self.timeRemaining > 0 {
                self.timeRemaining -= 1
            } else {
                self.stopCountdownTimer()
            }
        }
    }
    
    // finish countdown
    func stopCountdownTimer() {
        isRunning = false
        countdownTimer?.invalidate()
        countdownTimer = nil
    }
    
    // Convert time into string that can be displayed
    func timeString() -> String {
        let minutes = Int(timeRemaining) / 60
        let seconds = Int(timeRemaining) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

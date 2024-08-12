//
//  EatingTimerVIew.swift
//  Tummy
//
//  Created by Pei-Tzu Huang on 2024/8/12.
//

import SwiftUI

struct EatingTimerVIew: View {
    let timer = Timer.publish(every: 1.0, on: .main, in: .common).autoconnect()
    
    
    // Countdown to min
    
    @State var timeRemaining: String = ""
    let futureTime: Date = Calendar.current.date(byAdding: .minute, value: 25, to: Date()) ?? Date()
    
    func updateTimeRemaining() {
        let remaining = Calendar.current.dateComponents([.minute, .second], from: Date(), to: futureTime)
        let minute = remaining.minute ?? 0
        let second = remaining.second ?? 0
        timeRemaining = "\(minute) : \(second)"
    }

    
    
    
    
    var body: some View {
        VStack {
            Image("Tummy")
                .resizable()
                .frame(width: 150, height: 150)
                .scaledToFit()
            Text(timeRemaining)
                .font(.largeTitle)
            
            
        }
        .onReceive(timer, perform: { _ in
           updateTimeRemaining()
        })
    
     
    }
}

#Preview {
    EatingTimerVIew()
}

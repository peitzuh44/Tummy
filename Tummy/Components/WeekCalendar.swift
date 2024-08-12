//
//  WeekCalendar.swift
//  Tummy
//
//  Created by Pei-Tzu Huang on 2024/8/12.
//

import SwiftUI

struct WeekCalendar: View {
    
    @StateObject var manager: DateManager = DateManager()
    @Namespace var animation
    
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(manager.currentWeek, id: \.self) { day in
                    VStack (spacing: 2){
                        Text(manager.extractDate(date: day, format: "EEE"))
                        Text(manager.extractDate(date: day, format: "dd"))
                            .frame(width: 44, height: 44)
                        
                            .background(
                                ZStack {
                                    if manager.isToday(date: day) {
                                        Circle()
                                            .fill(Color.blue.opacity(0.3))
                                            .matchedGeometryEffect(id: "CURRENTDAY", in: animation)
                                    }
                                }
                            )
                    }
                    .onTapGesture {
                        withAnimation {
                            manager.currentDay = day
                        }
                    }
                }
            }
        }
        .scrollIndicators(.hidden)
       
    }
}

#Preview {
    WeekCalendar()
}

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
    @Binding var selectedDate: Date
    
    var body: some View {
        HStack {
            ForEach(manager.currentWeek, id: \.self) { day in
                VStack (alignment: .center, spacing: 2){
                    Text(manager.extractDate(date: day, format: "EEE"))
                        .font(.caption)
                    Text(manager.extractDate(date: day, format: "dd"))
                        .fontWeight(.semibold)
                   
                }
                .frame(width: 44, height: 60)
                .background(
                    ZStack {
                        if manager.isToday(date: day) {
                            RoundedRectangle(cornerRadius: 10.0)
                                .fill(.ultraThinMaterial)
                                .matchedGeometryEffect(id: "CURRENTDAY", in: animation)
                        }
                    }
                )
                .frame(maxWidth: .infinity)
                .onTapGesture {
                    withAnimation {
                        manager.currentDay = day
                        selectedDate = day
                        HapticManager.instance.impact(style: .light)
                    }
                }
            }
        }
               
    }
}


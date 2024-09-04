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
    
    @State private var weekTransition: AnyTransition = .identity
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16){
            Text("\(manager.currentDay.formattedDate(for: "MMMM dd, yyyy"))")
                .font(.title3)
                .padding(.horizontal, 8)
            VStack(spacing: 2) {
                // Weekdays
                HStack {
                    ForEach(manager.currentWeek, id: \.self) { day in
                        Text(manager.extractDate(date: day, format: "EEE"))
                            .font(.caption)
                            .frame(width: 40)
                            .frame(maxWidth: .infinity)
                    }
                }
                // Dates
                HStack {
                    ForEach(manager.currentWeek, id: \.self) { day in
                        VStack(alignment: .center, spacing: 2) {
                            Text(manager.extractDate(date: day, format: "dd"))
                                .fontWeight(.semibold)
                        }
                        .frame(width: 40, height: 40)
                        .background(
                            ZStack {
                                if manager.isToday(date: day) {
                                    RoundedRectangle(cornerRadius: 10.0)
                                        .fill(.ultraThinMaterial)
                                        .matchedGeometryEffect(id: "CURRENTDAY", in: animation)
                                }
                                if manager.isReferenceDate(date: day) {
                                    RoundedRectangle(cornerRadius: 10.0)
                                        .fill(.red.opacity(0.8))
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
        .transition(weekTransition)
        .gesture(
            DragGesture(minimumDistance: 50)
                .onEnded { value in
                    if value.translation.width > 0 {
                        // Swipe Right to fetch the previous week
                        weekTransition = .move(edge: .leading)
                        withAnimation {
                            manager.fetchPreviousWeek()
                            selectedDate = manager.currentDay
                        }
                    } else if value.translation.width < 0 {
                        // Swipe Left to fetch the next week (only if not future)
                        weekTransition = .move(edge: .trailing)
                        withAnimation {
                            manager.fetchNextWeek()
                            selectedDate = manager.currentDay
                        }
                    }
                    HapticManager.instance.impact(style: .medium)
                }
        )
    }
}

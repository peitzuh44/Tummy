//
//  DateManager.swift
//  Tummy
//
//  Created by Pei-Tzu Huang on 2024/8/12.
//

import Foundation
import SwiftUI

class DateManager: ObservableObject {
        
    @Published var currentWeek: [Date] = []
    @Published var currentDay: Date = Date()
    
    init() {
        fetchCurrentWeek()
    }
    
    // Fetch Current Week
    func fetchCurrentWeek() {
        let today: Date = Date()
        let calendar = Calendar.current
        let week = calendar.dateInterval(of: .weekOfMonth, for: today)
        
        guard let firstWeekday = week?.start else {
            return
        }
        
        (1...7).forEach { day in
            if let weekday = calendar.date(byAdding: .day, value: day, to: firstWeekday) {
                currentWeek.append(weekday)
            }
        }
    }
    
    // MARK: Extracting Date
    func extractDate(date: Date, format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
    
    // MARK: is today
    func isToday(date: Date) -> Bool {
        let calendar = Calendar.current
        return calendar.isDate(currentDay, inSameDayAs: date)
    }
}


extension Date {
    func formatted() -> String {
        let formatter = DateFormatter()
        let calendar = Calendar.current
        
        if calendar.isDateInToday(self) {
            formatter.dateFormat = "'Today' h:mm a"
        } else {
            formatter.dateFormat = "MM-dd h:mm a"
        }
        
        return formatter.string(from: self)
    }
}

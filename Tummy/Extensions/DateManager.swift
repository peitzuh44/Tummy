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
    private var referenceDate: Date = Date() // Keeps track of the current reference date

    
    init() {
        fetchCurrentWeek()
    }
    
    // Fetch Current Week
        func fetchCurrentWeek() {
            let calendar = Calendar.current
            let today = currentDay
            
            guard let currentMonday = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: today)) else {
                return
            }
            
            currentWeek = []
            for day in 0..<7 {
                if let weekday = calendar.date(byAdding: .day, value: day, to: currentMonday) {
                    currentWeek.append(weekday)
                }
            }
        }
        
        // Fetch Previous Week
        func fetchPreviousWeek() {
            let calendar = Calendar.current
            
            // Move current day back by 7 days
            if let previousWeekDay = calendar.date(byAdding: .day, value: -7, to: currentDay) {
                currentDay = previousWeekDay
                fetchCurrentWeek()
            }
        }
       func fetchNextWeek() {
           let calendar = Calendar.current
           
           // Move current day forward by 7 days
           if let nextWeekDay = calendar.date(byAdding: .day, value: 7, to: currentDay),
              nextWeekDay <= referenceDate {
               currentDay = nextWeekDay
               fetchCurrentWeek()
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
    // MARK: is reference date
    func isReferenceDate(date: Date) -> Bool {
        let calendar = Calendar.current
        return calendar.isDate(referenceDate, inSameDayAs: date)
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
    func formattedDate(for format: String) -> String {
        let formatter = DateFormatter()
        let calendar = Calendar.current
        
        if calendar.isDateInToday(self) {
            return "Today"
        } else {
            formatter.dateFormat = format

        }
        return formatter.string(from: self)

    }
    
}

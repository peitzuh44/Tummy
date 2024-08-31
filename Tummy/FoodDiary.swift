//
//  FoodDiary.swift
//  Tummy
//
//  Created by Pei-Tzu Huang on 2024/8/30.
//

import Foundation




struct FoodDiary: Identifiable, Codable {
    let id: String
    let isRealTime: Bool
    let photoURL: String?
    let textDescription: String?
    let hungerBefore: Int
    let time: Date
    let mealType: String?
    var location: String
    var eatAlone: Bool
    var people: String?
    var reason: String
    var fullnessAfter: Int
    var notes: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case isRealTime
        case photoURL
        case textDescription
        case hungerBefore
        case time
        case mealType
        case location
        case eatAlone
        case people
        case fullnessAfter
        case reason
        case notes
    }
    
    
}



enum Meal: Codable {
    case breakfast, lunch, dinner, snacks
    
    var text: String {
        switch self {
        case .breakfast:
            return "Breakfast"
        case .lunch:
            return "Lunch"
        case .dinner:
            return "Dinne"
        case .snacks:
            return "Snacks"
        }
    }
    
    var icon: String {
        switch self {
            
        case .breakfast:
            return "sun.horizon"
        case .lunch:
            return "sun.max"
        case .dinner:
            return "moon.stars"
        case .snacks:
            return "cup.and.saucer"
        }
    }
}

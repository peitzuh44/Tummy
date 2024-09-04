//
//  FoodEntry.swift
//  Tummy
//
//  Created by Pei-Tzu Huang on 2024/9/1.
//

import Foundation

struct FoodEntry: Identifiable, Codable {
    let id: String
    let createdBy: String
    let isRealTime: Bool
    let photoURL: String?
    let hungerBefore: Int
    let time: Date
    let mealType: String
    var location: [String]
    var eatAlone: Bool
    var people: [String?]
    var reason: [String]
    var fullnessAfter: Int
    var notes: String
    var postCompleted: Bool
    
    enum CodingKeys: String, CodingKey {
        case id
        case createdBy
        case isRealTime
        case photoURL
        case hungerBefore
        case time
        case mealType
        case location
        case eatAlone
        case people
        case fullnessAfter
        case reason
        case notes
        case postCompleted
    }
    
    
}


struct FoodItem: Identifiable, Codable {
    let id: String
    var name: String
    var quantity: Int
    var unit: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case quantity
        case unit
    }
}

extension FoodEntry {
    var mealTypeIcon: String {
        switch mealType.lowercased() {
        case "breakfast":
            return "sun.horizon"
        case "lunch":
            return "sun.max"
        case "dinner":
            return "moon.stars"
        case "snack":
            return "cup.and.saucer"
        default:
            return "questionmark.circle"
        }
    }
}

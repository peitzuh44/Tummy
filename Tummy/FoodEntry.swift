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
    let textDescription: String?
    let hungerBefore: Int
    let time: Date
    let mealType: String?
    var location: [String]
    var eatAlone: Bool
    var people: [String?]
    var reason: [String]
    var fullnessAfter: Int
    var notes: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case createdBy
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

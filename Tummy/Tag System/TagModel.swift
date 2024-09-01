//
//  TagModel.swift
//  Tummy
//
//  Created by Pei-Tzu Huang on 2024/8/14.
//

import Foundation

struct Tag: Identifiable, Codable {
    var id: String
    var createdBy: String
    var name: String
    var isSelected: Bool = false
    var category: TagCategory.RawValue
    
    enum CodingKeys: String, CodingKey {
        case id, createdBy, name, isSelected, category
    }
    
}

enum TagCategory: String, Codable, CaseIterable {
    case people, location, reason
    
    
}

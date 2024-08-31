//
//  TagManager.swift
//  Tummy
//
//  Created by Pei-Tzu Huang on 2024/8/14.
//

import Foundation

class TagManager: ObservableObject {
    @Published var tags: [Tag] = [
        Tag(name: "By Myself", category: .people),
        Tag(name: "Professor", category: .people),
        Tag(name: "Co-Workers", category: .people),
        Tag(name: "Family", category: .people),
        Tag(name: "Roommate", category: .people),
        Tag(name: "Pets", category: .people),
        Tag(name: "School", category: .location),
        Tag(name: "Home", category: .location),
        Tag(name: "Work", category: .location),
        Tag(name: "Bus", category: .location),
        Tag(name: "Library", category: .location),
        Tag(name: "Dining Hall", category: .location),
        //why eat tags
        Tag(name: "Hungry", category: .reason),
        Tag(name: "Social", category: .reason),
        Tag(name: "Craving", category: .reason),
        Tag(name: "Bored", category: .reason),
        Tag(name: "Tired", category: .reason),
        Tag(name: "Anxious", category: .reason),
        Tag(name: "Love the taste", category: .reason)

     ]
    @Published var isAddingNewTag: Bool = false
    @Published var newTagName: String = ""
    
    
    func addTag(_ name: String, _ category: TagCategory) {
          let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
          if !trimmedName.isEmpty {
              tags.append(Tag(name: trimmedName, isSelected: true, category: category))
              
          }
          isAddingNewTag = false
          newTagName = ""
      }
    
    func toggleSelection(of tag: Tag) {
        if let index = tags.firstIndex(where: { $0.id == tag.id }) {
            tags[index].isSelected.toggle()
        }
    }
    
}

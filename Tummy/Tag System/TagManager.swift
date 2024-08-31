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
        Tag(name: "School", category: .place),
        Tag(name: "Home", category: .place),
        Tag(name: "Work", category: .place),
        Tag(name: "Bus", category: .place),
        Tag(name: "Library", category: .place),
        Tag(name: "Dining Hall", category: .place)
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

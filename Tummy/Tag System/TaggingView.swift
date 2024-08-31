//
//  TaggingView.swift
//  Tummy
//
//  Created by Pei-Tzu Huang on 2024/8/14.
//

import SwiftUI

// https://www.youtube.com/watch?v=6aw1KaUg4MY

struct TaggingView: View {
    var promptText: String
    var category: TagCategory
    @StateObject var manager: TagManager
    @Binding var newTagName: String
    @Binding var selectedTags: [Tag]
    var body: some View {
        VStack (alignment: .leading){
            HStack (alignment: .center, spacing: 30){
                Text(promptText)
                    .fontWeight(.semibold)
                ChipTextField(title: "+", text: $newTagName, category: category, manager: manager, selectedTags: $selectedTags)
            }
            .padding(.vertical)
            TagLayout(alignment: .leading) {
                ForEach(manager.tags(forCategory: category.rawValue)) {
                    tag in
                    Chip(tag: tag)
                        .onTapGesture {
                            manager.toggleSelection(of: tag)
                            appendOrRemoveTag(tag: tag)
                            print(selectedTags)
                            
                        }
                }
            }
        }
        .padding()
    }
    private func appendOrRemoveTag(tag: Tag) {
        if tag.isSelected {
            if let index = selectedTags.firstIndex(where: { $0.id == tag.id }) {
                selectedTags.remove(at: index)
            }
        } else {
            selectedTags.append(tag)
        }
    }
}







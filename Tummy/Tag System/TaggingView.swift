//
//  TaggingView.swift
//  Tummy
//
//  Created by Pei-Tzu Huang on 2024/8/14.
//

import SwiftUI

// https://www.youtube.com/watch?v=6aw1KaUg4MY

struct TaggingView: View {
    @StateObject var viewModel: FoodEntryViewModel
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
                ChipTextField(viewModel: viewModel, title: "+", name: $newTagName, category: category, manager: manager, selectedTags: $selectedTags)
            }
            .padding(.vertical)
            TagLayout(alignment: .leading) {
                ForEach(viewModel.tags(forCategory: category.rawValue)) {
                    tag in
                    Chip(tag: tag)
                        .onTapGesture {
                            viewModel.toggleTags(tag: tag)
                        }
                }
            }
        }
        .padding()
        .onAppear {
            viewModel.fetchTags()
        }
    }

}







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
    @StateObject var manager: TagManager
    @Binding var newTagName: String
    var category: TagCategory
    
    var body: some View {
        VStack (alignment: .leading){
            
            HStack (alignment: .center, spacing: 30){
                Text(promptText)
                    .fontWeight(.semibold)
                
                ChipTextField(title: "+", text: $newTagName, category: category, manager: manager)
            }
            .padding(.vertical)
            TagLayout(alignment: .leading) {
                ForEach(manager.tags.filter{
                    $0.category == category
                }) {
                    tag in
                    Chip(tag: tag)
                        .onTapGesture {
                            manager.toggleSelection(of: tag)
                        }
                }
            }
            

        }
        .padding()



    }
    

}







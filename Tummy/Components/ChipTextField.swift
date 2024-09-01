//
//  ChipTextField.swift
//  Tummy
//
//  Created by Pei-Tzu Huang on 2024/8/14.
//

import SwiftUI

// MARK: Chip Textfield

struct ChipTextField: View {
    @StateObject var viewModel: FoodEntryViewModel
    let title: String
    @Binding var name: String
    var category: TagCategory
    @StateObject var manager: TagManager
    @Binding var selectedTags: [Tag]
    @State private var textRect = CGRect()
    
    var body: some View {
        ZStack {
            Text(name == "" ? title : name)
                .background(GlobalGeometryGetter(rect: $textRect)).layoutPriority(1).opacity(0)
            HStack {
                TextField(title, text: $name)
                    .font(.callout)
                    .onSubmit {
                        viewModel.createTag(name: name, category: category)
                        name = ""
                        
                    }
                .frame(width: textRect.width)
            }
            .padding(.horizontal)
            .padding(.vertical, 10)
            .background(
                Capsule()
                    .fill(Color(.systemGray6))
            )
        }
    }


}


struct GlobalGeometryGetter: View {
    @Binding var rect: CGRect

    var body: some View {
        return GeometryReader { geometry in
            self.makeView(geometry: geometry)
        }
    }

    func makeView(geometry: GeometryProxy) -> some View {
        DispatchQueue.main.async {
            self.rect = geometry.frame(in: .global)
        }

        return Rectangle().fill(Color.clear)
    }
}

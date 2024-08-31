//
//  ChipTextField.swift
//  Tummy
//
//  Created by Pei-Tzu Huang on 2024/8/14.
//

import SwiftUI

// MARK: Chip Textfield

struct ChipTextField: View {
    let title: String
    @Binding var text: String
    var category: TagCategory
    @StateObject var manager: TagManager

    @State private var textRect = CGRect()
    
    var body: some View {
        ZStack {
            Text(text == "" ? title : text)
                .background(GlobalGeometryGetter(rect: $textRect)).layoutPriority(1).opacity(0)
            HStack {
                TextField(title, text: $text)
                    .font(.callout)
                    .onSubmit {
                        manager.addTag(text, category)
                        text = ""
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

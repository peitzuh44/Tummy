//
//  Chip.swift
//  Tummy
//
//  Created by Pei-Tzu Huang on 2024/8/14.
//

import SwiftUI


struct Chip: View {
    var tag: Tag
    var body: some View {
        Text(tag.name)
            .font(.caption)
            .padding(.vertical, 8)
            .padding(.horizontal)
            .background(
                Capsule()
                    .stroke(Color.black, lineWidth: 1.0)
                    .fill(tag.isSelected ? Color.blue.opacity(0.7) : Color(.systemGray6))
            )
    }
    
}

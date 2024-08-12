//
//  SearchBar.swift
//  Tummy
//
//  Created by Pei-Tzu Huang on 2024/8/12.
//

import SwiftUI

struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            if text.isEmpty {
                Image(systemName: "magnifyingglass")
                    .imageScale(.large)
                    .foregroundStyle(.primary)
            }
            TextField("Search...", text: $text)
                .foregroundStyle(Color.primary)
        }
        .padding()
        .frame(height: 55)
        .background(
            RoundedRectangle(cornerRadius: 10.0)
                .fill(Color(.systemGray6))
        )
    }
}

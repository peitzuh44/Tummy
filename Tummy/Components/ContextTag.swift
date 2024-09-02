//
//  ContextTag.swift
//  Tummy
//
//  Created by Pei-Tzu Huang on 2024/9/2.
//

import Foundation
import SwiftUI

struct ContextTag: View {
    var contextTag: Tag
    var body: some View {
        Text(contextTag.name)
            .font(.caption2)
            .fontWeight(.medium)
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .background(
                RoundedRectangle(cornerRadius: 20.0)
                    .fill(Color(.systemGray5))
            )
    }
}
struct ContextStringTag: View {
    var text: String
    var body: some View {
        Text(text)
            .font(.caption2)
            .fontWeight(.medium)
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .background(
                RoundedRectangle(cornerRadius: 20.0)
                    .fill(Color(.systemGray5))
            )
    }
}

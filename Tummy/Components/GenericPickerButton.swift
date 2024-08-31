//
//  GenericPickerButton.swift
//  Tummy
//
//  Created by Pei-Tzu Huang on 2024/8/17.
//


import SwiftUI

struct GenericPickerButton<Content: View>: View {
    let pickerText: String
    let selectionText: String
    @Binding var isPresenting: Bool
    let content: () -> Content
    
    var body: some View {
        Button(action: {
            self.isPresenting = true
        }) {
            HStack {
                Text(pickerText)
                Spacer()
                Text(selectionText)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .foregroundColor(.white)
            .background(
                RoundedRectangle(cornerRadius: 20.0)
                    .fill(.thinMaterial)
            )
        }
        .sheet(isPresented: $isPresenting) {
            self.content()
        }
    }
}


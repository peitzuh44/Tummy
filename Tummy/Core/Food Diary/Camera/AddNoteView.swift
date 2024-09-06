//
//  AddNoteView.swift
//  Tummy
//
//  Created by Pei-Tzu Huang on 2024/9/2.
//

import SwiftUI

struct AddNoteView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var notes: String
    var body: some View {
        NavigationStack {
            VStack (alignment: .leading){
                Text("✏️ How are you feeling?")
                    .font(.title3)
                Divider()
                TextEditor(text: $notes)
                Spacer()
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Text("Save")
                        .font(.headline)
                        .foregroundStyle(Color.theme.inverseText)
                        .frame(maxWidth: .infinity)
                        .frame(height: 60)
                        .background(
                            RoundedRectangle(cornerRadius: 20.0)
                                .fill(Color.accentColor)
                        )
                }
            }
            .padding()
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("X")
                            .foregroundStyle(Color.accentColor)
                            .font(.title2)
                    }

                }
            }
        }
    }
}

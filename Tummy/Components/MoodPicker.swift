//
//  MoodPicker.swift
//  Tummy
//
//  Created by Pei-Tzu Huang on 2024/9/6.
//

import SwiftUI

struct MoodPicker: View {
    var body: some View {
                    VStack (alignment: .leading) {
                        Text("How do you feel after eating?")
                        HStack {
                            ForEach(Mood.allCases, id: \.self) { mood in
                                Image(mood.emoji)
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .padding(12)
                                    .background(
                                        RoundedRectangle(cornerRadius: 10.0)
                                            .fill(.thinMaterial)
                                    )
                            }
                        }
                    }
                    .padding(.vertical)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 30.0)
                            .fill(.thickMaterial)
                    )    }
}

//
//  PostFoodCheckInView.swift
//  Tummy
//
//  Created by Pei-Tzu Huang on 2024/8/16.
//

import SwiftUI

struct PostFoodCheckInView: View {
    @Environment(\.presentationMode) var presentationMode

    @State var selectedHunger: HungerScaleOption = .five
    @State private var showHungerScale: Bool = false

    var body: some View {
        // MARK: Fullness Scale
        NavigationStack {
            // MARK: Hunger Scale
            GenericPickerButton(pickerText: "Hunger Scale", selectionText: selectedHunger.text, isPresenting: $showHungerScale) {
                HungerScale(selectedHunger: $selectedHunger)
            }
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
            )
            
            Spacer()
            Button {
                presentationMode.wrappedValue.dismiss()
            } label: {
                Text("Complete Journal")
                    .foregroundStyle(Color.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .frame(height: 55)
                    .background(
                        RoundedRectangle(cornerRadius: 20.0)
                            .fill(Color.green)
                    )
            }
            
            .navigationTitle("Post Food Check-In")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("X")
                            .foregroundStyle(Color.white)
                            .font(.title2)
                    }

                }
            }
        }
    }
}

#Preview {
    PostFoodCheckInView()
}

enum Mood: String, CaseIterable {
    case veryBad, bad, ok, good, veryGood
    
    var emoji: String {
        switch self {
        case .veryBad:
            return "verySad"
        case .bad:
            return "sad"
        case .ok:
            return "neutral"
        case .good:
            return "happy"
        case .veryGood:
            return "veryHappy"
        }
    }
}

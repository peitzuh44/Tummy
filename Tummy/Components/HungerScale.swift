//
//  HungerScale.swift
//  Tummy
//
//  Created by Pei-Tzu Huang on 2024/8/17.
//

import SwiftUI

struct HungerScale: View {
    @Environment(\.presentationMode) var presentationMode

    @Binding var selectedHunger: HungerScaleOption
    var body: some View {
            ScrollView {
                VStack (alignment: .leading){
                    Text("Description")
                    Divider()
                    Text(selectedHunger.description)
                        .font(.headline)

                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 30.0)
                        .fill(.thinMaterial)
                )
                VStack {
                    ForEach(HungerScaleOption.allCases, id: \.self) {
                        option in
                        Button {
                            self.selectedHunger = option
                        } label: {
                            HStack {
                                HStack {
                                    Text(option.numberString)
                                    Text(option.text)
                                }
                                Spacer()
                                if selectedHunger == option {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(.green)
                                                  }
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .frame(height: 55)
                            .background(
                                RoundedRectangle(cornerRadius: 20.0)
                                    .fill(.thinMaterial)
                            )
                        }

                    }
                    
                }
                VStack {
                    
                }
                .frame(height: 60)
            }
            .scrollIndicators(.hidden)
            
        
        .overlay(alignment: .bottom, content: {
            Button {
                presentationMode.wrappedValue.dismiss()
            } label: {
                Text("Done")
                    .foregroundStyle(Color.inverseText)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .frame(height: 55)
                    .background(
                        RoundedRectangle(cornerRadius: 20.0)
                            .fill(Color.accentColor)
                    )
            }

        })
        .padding()
         
        
    }
}



enum HungerScaleOption: String, CaseIterable {
    case one, two, three, four, five, six, seven, eight, nine, ten
    
    var text: String {
        switch self {
        case .one:
            return "Ravenous"
        case .two:
            return "Uncomfortly Hungry"
        case .three:
            return "Very Hungry"
        case .four:
            return "A Little Hungry"
        case .five:
            return "Neutral"
        case .six:
            return "Satified"
        case .seven:
            return "Full"
        case .eight:
            return "Very Full"
        case .nine:
            return "Very Uncomfortable"
        case .ten:
            return "Binged. Painfully full..."
        }
    }
    
    var numberString: String {
        switch self {
        case .one:
            return "1"
        case .two:
            return "2"
        case .three:
            return "3"
        case .four:
            return "4"
        case .five:
            return "5"
        case .six:
            return "6"
        case .seven:
            return "7"
        case .eight:
            return "8"
        case .nine:
            return "9"
        case .ten:
            return "10"
        }
        
     
    }
    
    var number: Int {
        switch self {
        case .one:
            return 1
        case .two:
            return 2
        case .three:
            return 3
        case .four:
            return 4
        case .five:
            return 5
        case .six:
            return 6
        case .seven:
            return 7
        case .eight:
            return 8
        case .nine:
            return 9
        case .ten:
            return 10
        }
    }
    
    // Description
    
    var description: String {
        switch self {
            
        case .one:
            return "starving, weak, dizzy"
        case .two:
            return "irratable, low energy"
        case .three:
            return "stomach growling"
        case .four:
            return "thought turn to food"
        case .five:
            return "neither hungry nor full"
        case .six:
            return "slightly full with no discomfort"
        case .seven:
            return "full enough for mild discomfort"
        case .eight:
            return "stuffed, notable discomfort"
        case .nine:
            return "Thanksgiving-stuffed"
        case .ten:
            return "I feel sick... Painfully discomfort"
        }
    }
 
    
}

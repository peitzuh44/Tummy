//
//  WhySkipView.swift
//  Tummy
//
//  Created by Pei-Tzu Huang on 2024/8/16.
//

import SwiftUI

struct WhySkipView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @State var customizeReason: String = ""
    @State private var reasonsForSkipping: [String] = [
        "I don't have time.",
        "I feel upset so I don't want to eat.",
        "I'm still full from last meal.",
        "I'm not hungry"
    ]
    
    var body: some View {
        NavigationStack{
            VStack {
                ScrollView {
                    VStack {
                        ForEach(reasonsForSkipping, id:\.self) { reason in
                            HStack{
                                Text(reason)
                                Spacer()
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(
                                RoundedRectangle(cornerRadius: 10.0)
                                    .fill(.thinMaterial)
                            )
                        }
                    }
                    Divider()
                    TextField("write your own reason here...", text: $customizeReason)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(.thinMaterial)
                                .font(.headline)
                            )
                }
                Button {
                    
                } label: {
                    Text("Done")
                        .foregroundStyle(Color.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .frame(height: 55)
                        .background(
                            RoundedRectangle(cornerRadius: 20.0)
                                .fill(Color.blue)
                        )
                }

            }
            .padding()
            .navigationTitle("Reason for skipping")
            
        }
    }
}

#Preview {
    WhySkipView()
}





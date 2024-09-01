//
//  EntryDetailView.swift
//  Tummy
//
//  Created by Pei-Tzu Huang on 2024/8/31.
//

import SwiftUI

struct EntryDetailView: View {
    var entry: FoodDiary

    var body: some View {
        ScrollView {
            VStack(alignment: .leading){
                
                // Food Photo
                Image("Food")
                    .resizable()
                    .frame(height: 500)
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
                    .clipShape(
                        Rectangle()
                    )
                
                // Info
                VStack(alignment: .leading){
                    HStack {
                        VStack (alignment: .leading){
                            VStack(alignment: .leading){
                                Text("Pei's breakfast")
                                    .font(.title2)
                                Text("August 30, 2024 12:34pm")
                                    .font(.caption)
                                Text("School | Ryan Ma | Social")
                                    .font(.caption)
                            }
                            .padding(.bottom)
                            
//                            // People
//                            VStack(alignment:.leading){
//                                Text("People")
//                                
//                                Text("You ate your meal alone.")
//                                    .font(.caption)
//                            }
//                            .padding(.vertical, 8)
//                            
//                            // Place
//                            VStack(alignment:.leading){
//                                Text("Place")
//                                HStack {
//                                    ForEach(locations) { location in
//                                        ContextTag(contextTag: location)
//                                    }
//                                }
//                            }
//                            .padding(.vertical, 8)
//                            // Place
//                            VStack(alignment:.leading){
//                                Text("Reason")
//                                HStack {
//                                    ForEach(reasons) { reason in
//                                        ContextTag(contextTag: reason)
//                                    }
//                                }
//                            }
//                            .padding(.vertical, 8)
                            
                            // Notes
                            VStack (alignment: .leading){
                                Text("Notes")
                                Text("I really enjoy the food.")
                            }
                            
                            VStack {
                                
                            }
                            .frame(height: 70)
                            
                        }
                      
                        Spacer()
                    }
                    .padding()
                    
                }
                .frame(maxWidth: .infinity)
            }
        }
        .ignoresSafeArea(.container)
        .scrollIndicators(.never)
    }
}


//
//  EntryItem.swift
//  Tummy
//
//  Created by Pei-Tzu Huang on 2024/8/31.
//

import SwiftUI


struct EntryItem: View {
    @State var people: [Tag] = [
        Tag(name: "professor", category: .people),
        Tag(name: "Ryan Ma", category: .people),
    ]
    @State var locations: [Tag] = [
        Tag(name: "School", category: .location)
    ]
    @State var reasons: [Tag] = [
        Tag(name: "Social", category: .reason)
    ]
    var body: some View {
        VStack {
            // Prompt
            HStack {
                Spacer()
                Text("Post meal questionnaire >>")
            }
            .font(.caption)
            
            VStack {
                
                HStack (spacing: 16){
                    VStack {
                        Image("Food")
                            .resizable()
                            .scaledToFit()
                            .clipShape(
                                RoundedRectangle(cornerRadius: 10.0)
                                
                            )
                            .frame(height: 150)
                    }
                    
                    VStack(alignment: .leading, spacing: 8){
                        HStack {
                            Image(systemName: "sun.horizon")
                            Text("Breakfast")
                            
                        }
                        .font(.headline)
                        Divider()
                        // Context tags
                        VStack(alignment: .leading, spacing: 8){
                            HStack {
                                Text("People")
                                    .font(.caption)
                                ScrollView(.horizontal){
                                    HStack {
                                        ForEach(people) { tag in
                                            ContextTag(contextTag: tag)
                                        }
                                    }
                                }
                                .scrollIndicators(.hidden)
                            }
                            HStack {
                                Text("Place")
                                    .font(.caption)
                                ScrollView(.horizontal){
                                    HStack {
                                        ForEach(locations) { tag in
                                            ContextTag(contextTag: tag)
                                        }
                                    }
                                }
                                .scrollIndicators(.hidden)
                            }
                            HStack {
                                Text("Reason")
                                    .font(.caption)
                                ScrollView(.horizontal){
                                    HStack {
                                        ForEach(reasons) { tag in
                                            ContextTag(contextTag: tag)
                                        }
                                    }
                                }
                                .scrollIndicators(.hidden)
                            }
                            HStack {
                                Text("Hungerness")
                                    .font(.caption)
                                HStack {
                                    Text("3")
                                    
                                    Image(systemName: "arrow.forward")
                                    
                                    Text("7")
                                    
                                }
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
                        
                        
                    }
                    
                    
                    
                    
                    
                }
                Divider()
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("🍜 Dry noodle")
                            .font(.headline)
                        Spacer()
                        Text("1 box")
                    }
                    
                    HStack {
                        Text("🍕 Hawaii Pizza")
                            .font(.headline)
                        Spacer()
                        Text("2 slices")
                    }
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 10.0)
                    .fill(.ultraThinMaterial)
            )
            HStack {
                Spacer()
                Text("Today 07:33pm")
            }
            .font(.caption2)
        }
    }
}

#Preview {
    EntryItem()
}

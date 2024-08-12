//
//  FoodTemplateSheet.swift
//  Tummy
//
//  Created by Pei-Tzu Huang on 2024/8/12.
//

import SwiftUI

struct FoodTemplateSheet: View {
    
    @Environment(\.presentationMode) var presentationMode

    @StateObject var vm: FoodJournalViewModel = FoodJournalViewModel()
    
    @State private var searchTerm: String = ""
    
    
    var filteredTemplates: [String] {
        guard !searchTerm.isEmpty else {
            return vm.foodTemplates
        }
        return vm.foodTemplates.filter {
            $0.localizedCaseInsensitiveContains(searchTerm)
        }
        
    }
    
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    Button {
                        // Action
                    } label: {
                        HStack {
                            Image(systemName: "plus.circle")
                            Text("Create \(searchTerm)")
                            
                        }
                    }
                    ForEach(filteredTemplates, id: \.self) { template in
                        HStack {
                            Text(template)
                        }
                    }
                }
                .searchable(text: $searchTerm, prompt: "Search for food")
                
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                    }

                }
            }
        }
    }
}

#Preview {
    FoodTemplateSheet()
}

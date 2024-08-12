//
//  FoodJournalViewModel.swift
//  Tummy
//
//  Created by Pei-Tzu Huang on 2024/8/12.
//

import Foundation

class FoodJournalViewModel: ObservableObject {
    
    @Published var foodJournals: [String] = [
        "Banana", "Apple", "Chicken"
    ]
    
    @Published var foodTemplates: [String] = [
        "Banana", "Apple", "Chicken", "Beef", "Egg"
    ]
    
    // MARK: Fetch Food Journal
    
}

//
//  MoodManager.swift
//  Tummy
//
//  Created by Pei-Tzu Huang on 2024/8/12.
//

import Foundation

class MoodManager: ObservableObject {
    @Published var moods: [String] = [
        "Happy", "Excited", "Sad", "Angry", "Lost"
    ]
    
    // MARK: Fetch mood
    func fetchMood() {
        
    }
}

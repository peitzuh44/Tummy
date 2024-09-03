//
//  HapticManager.swift
//  Tummy
//
//  Created by Pei-Tzu Huang on 2024/9/3.
//

import Foundation
import SwiftUI


class HapticManager {
    static let instance = HapticManager()
    
    func notifiction(type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(type)
    }
    
    func impact(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()

    }
    
}

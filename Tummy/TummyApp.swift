//
//  TummyApp.swift
//  Tummy
//
//  Created by Pei-Tzu Huang on 2024/8/12.
//

import SwiftUI
import FirebaseCore

@main
struct TummyApp: App {
    init() {
        FirebaseApp.configure()
    } 
    var body: some Scene {
        WindowGroup {
            AuthView()
        }
    }
}

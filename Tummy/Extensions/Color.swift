//
//  Color.swift
//  Tummy
//
//  Created by Pei-Tzu Huang on 2024/8/14.
//

import Foundation
import SwiftUI

extension Color {
    
    static let theme: ColorTheme = ColorTheme()
    
    public static let babyBlue: Color = Color(red: 0/255, green: 150/255, blue: 255/255)
    public static let babyPurple: Color = Color(red: 122/255, green: 129/255, blue: 255/255)

    public static let babyPink: Color = Color(red: 203/255, green: 131/255, blue: 255/255)

    
    
    
}

struct ColorTheme {
    let accent = Color("AccentColor")
    let background = Color("BackgroundColor")
    
}

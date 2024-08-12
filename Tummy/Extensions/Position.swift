//
//  Position.swift
//  Tummy
//
//  Created by Pei-Tzu Huang on 2024/8/12.
//

import Foundation
import SwiftUI

extension View {
    func hLeading() -> some View {
        self
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    func hCenter() -> some View {
        self
            .frame(maxWidth: .infinity, alignment: .center)
    }
    
    func hTrailing() -> some View {
        self
            .frame(maxWidth: .infinity, alignment: .trailing)
    }
    
}

//
//  FloatingActionButton.swift
//  Tummy
//
//  Created by Pei-Tzu Huang on 2024/8/12.
//

import SwiftUI

struct FloatingActionButton: View {
    
    @Binding var showSheet: Bool
    
    var body: some View {
        Button {
            showSheet = true
        } label: {
            ZStack {
                Circle()
                    .fill(Color.blue)
                    .frame(width: 70, height: 70)
                Image(systemName: "plus")
                    .resizable()
                    .frame(width: 30, height: 30)

                    .foregroundStyle(Color.white)
                    .bold()
                    
            }
        }
    
    }
}



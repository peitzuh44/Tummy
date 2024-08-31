//
//  DetailPage.swift
//  Tummy
//
//  Created by Pei-Tzu Huang on 2024/8/14.
//

import SwiftUI

struct DetailPage: View {
    @Namespace var namespace
    @Binding var showDetail: Bool
    
    let gradient = LinearGradient(colors: [Color.yellow, Color.orange], startPoint: .topLeading, endPoint: .bottomTrailing)
    
    var body: some View {
        ZStack {
            Color(.systemBackground).ignoresSafeArea(.all)
            Ellipse()
                .rotation(Angle(degrees: -90))
                .fill(gradient)
                .ignoresSafeArea(.all)
                .offset(x:0, y: -260)
            VStack {
                Text("Breakfast")
                    .matchedGeometryEffect(id: "Breakfast", in: namespace)
                
            }
        }
        .onTapGesture {
            withAnimation {
                showDetail = false

            }
        }
    }
}

#Preview {
    DetailPage(showDetail: .constant(true))
}

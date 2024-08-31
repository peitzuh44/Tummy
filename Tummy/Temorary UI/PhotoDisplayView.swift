//
//  PhotoDisplayView.swift
//  Tummy
//
//  Created by Pei-Tzu Huang on 2024/8/17.
//

import SwiftUI

struct PhotoDisplayView: View {
    let image: UIImage
    @Binding var showPhotoDisplayView: Bool

    var body: some View {
        VStack {
            Image(uiImage: image)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.black)
                .edgesIgnoringSafeArea(.all)
            
            Button("Close") {
                showPhotoDisplayView = false
            }
            .padding()
            .background(Color.red)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
    }
}

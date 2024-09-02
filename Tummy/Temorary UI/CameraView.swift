//
//  SwiftUIView.swift
//  Tummy
//
//  Created by Pei-Tzu Huang on 2024/9/2.
//

import SwiftUI
import UIKit

struct CameraView: UIViewControllerRepresentable {
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        var parent: CameraView

        init(parent: CameraView) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.image = image
            }
            parent.presentationMode.wrappedValue.dismiss()

            // Introduce a delay before showing the ThirdView
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { // Adjust the delay as needed
                self.parent.showPrefoodCheckIn = true
            }
        }


        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }

    @Environment(\.presentationMode) var presentationMode
    @Binding var image: UIImage?
    @Binding var showPrefoodCheckIn: Bool
    var sourceType: UIImagePickerController.SourceType = .camera

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = sourceType
        picker.allowsEditing = false
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
}


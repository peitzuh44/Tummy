//
//  CameraPreview.swift
//  Tummy
//
//  Created by Pei-Tzu Huang on 2024/8/17.
//
import UIKit
import AVFoundation
import SwiftUI

struct CameraPreview: UIViewControllerRepresentable {
    @Binding var capturedPhoto: UIImage?

    class Coordinator: NSObject, AVCapturePhotoCaptureDelegate {
        var parent: CameraPreview
        var session: AVCaptureSession?
        var output: AVCapturePhotoOutput?
        
        init(parent: CameraPreview) {
            self.parent = parent
            super.init()
            configureCaptureSession()
        }
        
        func configureCaptureSession() {
            session = AVCaptureSession()
            session?.beginConfiguration()
            session?.sessionPreset = .photo
            
            let camera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back)
            let input = try? AVCaptureDeviceInput(device: camera!)
            session?.addInput(input!)
            
            output = AVCapturePhotoOutput()
            output?.isHighResolutionCaptureEnabled = true
            session?.addOutput(output!)
            
            session?.commitConfiguration()
            session?.startRunning()
        }
        
        @objc func takePhoto() {
            let settings = AVCapturePhotoSettings()
            settings.isHighResolutionPhotoEnabled = true
            output?.capturePhoto(with: settings, delegate: self)
        }
        
        func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
            if let imageData = photo.fileDataRepresentation() {
                parent.capturedPhoto = UIImage(data: imageData)
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = UIViewController()
        let previewLayer = AVCaptureVideoPreviewLayer(session: context.coordinator.session!)
        previewLayer.videoGravity = .resizeAspectFill
        viewController.view.layer.addSublayer(previewLayer)
        previewLayer.frame = viewController.view.frame
        
        let button = UIButton(type: .custom)
        button.setTitle("Capture", for: .normal)
        button.backgroundColor = UIColor.red.withAlphaComponent(0.6)
        button.frame = CGRect(x: (viewController.view.frame.width - 100) / 2, y: viewController.view.frame.height - 120, width: 100, height: 50)
        button.addTarget(context.coordinator, action: #selector(context.coordinator.takePhoto), for: .touchUpInside)
        viewController.view.addSubview(button)
        
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}

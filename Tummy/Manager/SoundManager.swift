//
//  SoundManager.swift
//  Tummy
//
//  Created by Pei-Tzu Huang on 2024/8/17.
//

import SwiftUI
import AVFoundation

class SoundManager: NSObject, AVAudioPlayerDelegate {
    static let shared = SoundManager()
    
    var audioPlayer: AVAudioPlayer?
    var onFinishedPlaying: (() -> Void)?
    
    private override init() {
        super.init()
    }
    
    func playSound(filename: String, fileType: String) {
        if let audioPath = Bundle.main.path(forResource: filename, ofType: fileType) {
            let url = URL(fileURLWithPath: audioPath)
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: url)
                audioPlayer?.delegate = self
                audioPlayer?.play()
            } catch {
                print("Error playing audio: \(error.localizedDescription)")
            }
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        onFinishedPlaying?()
    }
    
    
}

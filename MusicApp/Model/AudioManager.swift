//
//  AudioManager.swift
//  MusicApp
//
//  Created by Erkam Karaca on 12.05.2023.
//

import Foundation
import AVFoundation

class AudioManager {
    static let shared = AudioManager()
    var player: AVPlayer?
    
    private init() {}
    
    func playFromURL(urlString: String) {
        AudioManager.shared.stop()
        guard let url = URL(string: urlString) else {
            print(MyError.URL_ERROR)
            print(MyError.TRACK_CAN_NOT_PLAYED_ERROR)
            return
        }
        AudioManager.shared.player = AVPlayer(url: url)
        AudioManager.shared.player?.play()
    }
    
    func stop() {
        AudioManager.shared.player?.pause()
        AudioManager.shared.player = nil
    }
}


//
//  AudioPlayer.swift
//  MusicApp
//
//  Created by Erkam Karaca on 12.05.2023.
//

import Foundation
import AVFoundation

class AudioPlayer {
    var player: AVPlayer?
    
    func playFromURL(urlString: String) {
        guard let url = URL(string: urlString) else {
            print(MyError.URL_ERROR)
            print(MyError.TRACK_CAN_NOT_PLAYED_ERROR)
            return
        }
        player = AVPlayer(url: url)
        player?.play()
    }
    
    func stopPlayback() {
        player?.pause()
    }
}

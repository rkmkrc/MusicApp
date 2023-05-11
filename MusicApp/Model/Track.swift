//
//  Track.swift
//  MusicApp
//
//  Created by Erkam Karaca on 11.05.2023.
//

import Foundation

struct TrackCollection: Codable {
    let data: [Track]?
}

struct Track: Codable {
    let id: Int?
    let title: String?
    let duration: Int?
    let preview: String?
}

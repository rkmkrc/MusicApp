//
//  Album.swift
//  MusicApp
//
//  Created by Erkam Karaca on 10.05.2023.
//

import Foundation

struct AlbumCollection: Codable {
    let data: [Album]?
}
struct Album: Codable {
    let innerAlbum: InnerAlbum?
    
    enum CodingKeys: String, CodingKey {
        case innerAlbum = "album"
    }
}

struct InnerAlbum: Codable {
    let id: Int?
    let title: String?
    let pictureLink: String?
    let tracklistLink: String?
    
    enum CodingKeys: String, CodingKey {
        case pictureLink = "cover_big"
        case tracklistLink = "tracklist"
        case id, title
    }
}

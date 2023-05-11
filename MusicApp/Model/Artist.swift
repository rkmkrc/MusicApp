//
//  Artist.swift
//  MusicApp
//
//  Created by Erkam Karaca on 9.05.2023.
//

import Foundation

struct ArtistCollection: Codable {
    let data: [Artist]?
}

struct Artist: MyProtocol, Codable {
    let id: Int?
    let name: String?
    let pictureLink: String?
    let tracklistLink: String?
    let type: String?

    enum CodingKeys: String, CodingKey {
        case pictureLink = "picture_big"
        case tracklistLink = "tracklist"
        case id, name, type
    }
}

//
//  Genre.swift
//  MusicApp
//
//  Created by Erkam Karaca on 8.05.2023.
//

import Foundation

struct Genres: Codable {
    let data: [Genre]?
}

struct Genre: MyProtocol, Codable {
    let id: Int?
    let name: String?
    let pictureLink: String?
    let type: String?
    
    enum CodingKeys: String, CodingKey {
        case pictureLink = "picture_big"
        case id, name, type
    }
}

protocol MyProtocol {
    var id: Int? { get }
    var name: String? { get }
    var pictureLink: String? { get }
}

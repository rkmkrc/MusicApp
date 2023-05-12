//
//  Constants.swift
//  MusicApp
//
//  Created by Erkam Karaca on 8.05.2023.
//

import Foundation

struct Constants {
    static let GENRE_NAME = "GenreName"
    static let GENRES_TITLE = "Genres"
    static let ARTISTS_TITLE = "Artists"
    static let ALBUM_DATE = "01.01.2023"
    static let DEFAULT_NUM_OF_CELLS = 5
    static let NUMBER_OF_ITEMS_PER_ROW_GENRES = 2.0
    static let SPACING_FOR_GENRE_CELLS = 10.0
    static let GENRE_CELL_RADIUS = 10.0
    static let BORDER_WIDTH = 1.0
}

func secondsToMinutesAndSeconds(seconds: Int) -> String {
    let minutes = seconds / 60
    let remainingSeconds = seconds % 60
    return String("\(minutes):\(remainingSeconds)\"")
}


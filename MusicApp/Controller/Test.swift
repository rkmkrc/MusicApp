//
//  Test.swift
//  MusicApp
//
//  Created by Erkam Karaca on 13.05.2023.
//

import Foundation
import UIKit

class Test: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let track = Track(id: 1, title: "Title", duration: 0, preview: "link")
        let track2 = Track(id: 2, title: "Title1", duration: 0, preview: "link")
        var fm = FavoriteManager()
        fm.addToFavorites(track: track)
        fm.addToFavorites(track: track)
        fm.addToFavorites(track: track2)
        fm.addToFavorites(track: track2)
        print(fm.isInFavorites(track: track))
        print(fm.isInFavorites(track: track2))
        print(fm.isInFavorites(track: Track(id: 3, title: "", duration: 4, preview: "")))
        fm.deleteFavoriteTrack(track: track)
        var favTracks = fm.getAllFavoriteTracks()
        for t in favTracks {
            print(t.id)
        }
        
       // fm.deleteFavoriteTrack(favoriteTrack: fm.turnTrackToFavoriteTrack(track: track))
       // favTracks = fm.getAllFavoriteTracks()
       // print(favTracks)
        
       // print(fm.isInFavorites(track: track2))
    }
}

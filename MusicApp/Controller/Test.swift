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
        var fm = FavoriteManager()
        fm.deleteAllFavoriteTracks()
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

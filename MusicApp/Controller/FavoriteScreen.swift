//
//  FavoriteScreen.swift
//  MusicApp
//
//  Created by Erkam Karaca on 13.05.2023.
//

import Foundation
import UIKit

class FavoriteScreen: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var favoriteTracksCollectionView: UICollectionView!
    
    var favoriteManager = FavoriteManager()
    var favoriteTracksList: [FavoriteTrack]? = [] {
        didSet {
            favoriteTracksCollectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = Constants.FAVORITE_SCREEN_TITLE
        favoriteTracksList = favoriteManager.getAllFavoriteTracks()
        setupCollectionView()
        NotificationCenter.default.addObserver(self, selector: #selector(
            self.reloadMyTable(notification:)), name: Notification.Name("reloadTable"),
                                               object: nil)
    }
    
    func setupCollectionView() {
        favoriteTracksCollectionView.dataSource = self
        favoriteTracksCollectionView.delegate = self
        favoriteTracksCollectionView.register(UINib(nibName: "TrackCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "TrackCollectionViewCell")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favoriteTracksList?.count ?? Constants.DEFAULT_NUM_OF_CELLS
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let favoriteTrack = favoriteTracksList?[indexPath.row] {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TrackCollectionViewCell", for: indexPath) as! TrackCollectionViewCell
            let int64ID: Int64 = favoriteTrack.id
            let intID: Int? = Int(int64ID)
            let int64Dur: Int64 = favoriteTrack.duration
            let intDur: Int? = Int(int64Dur)
            let track = Track(id: intID, title: favoriteTrack.title, duration: intDur, preview: favoriteTrack.preview)
            cell.track = track
            cell.setupCell(innerAlbum: nil)
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let collectionView = self.favoriteTracksCollectionView{
            return CGSize(width: collectionView.bounds.width - 2 * Constants.SPACING_FOR_GENRE_CELLS, height: collectionView.bounds.height / 5)
        } else {
            return CGSize(width: 0, height: 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let urlString = favoriteTracksList?[indexPath.row].preview {
            AudioManager.shared.playFromURL(urlString: urlString)
        }
    }
    
    @objc func reloadMyTable(notification: Notification) {
        self.favoriteTracksList = favoriteManager.getAllFavoriteTracks()
        self.favoriteTracksCollectionView.reloadData()
    }
}

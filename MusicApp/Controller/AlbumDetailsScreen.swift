//
//  AlbumDetailsScreen.swift
//  MusicApp
//
//  Created by Erkam Karaca on 11.05.2023.
//

import Foundation
import UIKit

class AlbumDetailsScreen: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var tracksCollectionView: UICollectionView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    var innerAlbum: InnerAlbum?
    var trackList: [Track]? = [] {
        didSet {
            tracksCollectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = innerAlbum?.title
        setupCollectionView()
        getAlbumDetails()
        NotificationCenter.default.addObserver(self, selector: #selector(
            self.reloadMyTable(notification:)), name: Notification.Name("reloadTable"),
                                               object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        spinner.startAnimating()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        spinner.stopAnimating()
    }
    
    func setupCollectionView() {
        tracksCollectionView.dataSource = self
        tracksCollectionView.delegate = self
        tracksCollectionView.register(UINib(nibName: "TrackCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "TrackCollectionViewCell")
    }
    
    func getAlbumDetails() {
        guard let url = URL(string: innerAlbum?.tracklistLink ?? "") else {
            print(MyError.URL_ERROR)
            return
        }
        fetchData(from: url, expecting: TrackCollection.self) { result in
            switch result {
            case .success(let trackCollection):
                DispatchQueue.main.async {
                    self.trackList = trackCollection.data
                    self.tracksCollectionView.reloadData()
                    self.spinner.stopAnimating()
                    self.spinner.isHidden = true
                }
            case .failure(let error):
                print(MyError.DATA_ERROR + " \(error)")
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return trackList?.count ?? Constants.DEFAULT_NUM_OF_CELLS
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let track = trackList?[indexPath.row] {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TrackCollectionViewCell", for: indexPath) as! TrackCollectionViewCell
            cell.track = track
            cell.innerAlbum = innerAlbum
            cell.setupCell(pictureLink: innerAlbum?.pictureLink)
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let collectionView = self.tracksCollectionView{
            return CGSize(width: collectionView.bounds.width - 2 * Constants.SPACING_FOR_GENRE_CELLS, height: collectionView.bounds.height / 5)
        } else {
            return CGSize(width: 0, height: 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let urlString = trackList?[indexPath.row].preview {
            AudioManager.shared.playFromURL(urlString: urlString)
        }
    }
    
    @objc func reloadMyTable(notification: Notification) {
        self.tracksCollectionView.reloadData()
    }
}

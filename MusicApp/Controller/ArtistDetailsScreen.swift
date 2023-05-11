//
//  ArtistDetailsScreen.swift
//  MusicApp
//
//  Created by Erkam Karaca on 10.05.2023.
//

import Foundation
import UIKit
import Kingfisher

class ArtistDetailsScreen: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var artistBGImageView: UIImageView!
    @IBOutlet weak var artistFGImageView: UIImageView!
    @IBOutlet weak var albumsCollectionView: UICollectionView!
    
    var urlComponents = URLComponents()
    var artist: Artist?
    var albumList: [Album]? = [] {
        didSet {
            albumsCollectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = artist?.name
        getAlbums()
        setImage()
        setupCollectionView()
    }
    
    func setImage() {
        let imageUrl = URL(string: artist?.pictureLink ?? "")
        artistBGImageView.kf.setImage(with: imageUrl, placeholder: UIImage(named: "personPlaceholder.png"), options: [.transition(.fade(0.2))], completionHandler: { result in
            switch result {
            case .success(_):
                self.blurImage(imageView: self.artistBGImageView)
                self.artistFGImageView.kf.setImage(with: imageUrl, placeholder: UIImage(named: "personPlaceholder.png"))
                break
            case .failure(_):
                self.artistBGImageView.image = UIImage(named: "personPlaceholder.png")
                print(MyError.IMAGE_DOWNLOAD_ERROR)
                break
            }
        })
    }
    
    func blurImage(imageView: UIImageView) {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        imageView.addSubview(blurEffectView)
        blurEffectView.topAnchor.constraint(equalTo: imageView.topAnchor).isActive = true
        blurEffectView.leadingAnchor.constraint(equalTo: imageView.leadingAnchor).isActive = true
        blurEffectView.trailingAnchor.constraint(equalTo: imageView.trailingAnchor).isActive = true
        blurEffectView.bottomAnchor.constraint(equalTo: imageView.bottomAnchor).isActive = true
    }
    
    func setupCollectionView() {
        albumsCollectionView.dataSource = self
        albumsCollectionView.delegate = self
        albumsCollectionView.register(UINib(nibName: "AlbumCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "AlbumCollectionViewCell")
    }
    
    func getAlbums() {
        guard let url = URL(string: artist?.tracklistLink ?? "") else {
            print(MyError.URL_ERROR)
            return
        }
        fetchData(from: url, expecting: AlbumCollection.self) { result in
            switch result {
            case .success(let albumsCollection):
                DispatchQueue.main.async {
                    self.albumList = albumsCollection.data
                    self.albumsCollectionView.reloadData()
                }
            case .failure(let error):
                print(MyError.DATA_ERROR + " \(error)")
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return albumList?.count ?? Constants.DEFAULT_NUM_OF_CELLS
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let album = albumList?[indexPath.row] {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AlbumCollectionViewCell", for: indexPath) as! AlbumCollectionViewCell
            cell.setupCell(innerAlbum: album.innerAlbum)
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let collectionView = self.albumsCollectionView{
            return CGSize(width: collectionView.bounds.width - 2 * Constants.SPACING_FOR_GENRE_CELLS, height: collectionView.bounds.height / 4)
        } else {
            return CGSize(width: 0, height: 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "albumToAlbumDetails", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "albumToAlbumDetails" {
            if let indexPaths = albumsCollectionView.indexPathsForSelectedItems, let indexPath = indexPaths.first {
                let selectedAlbum = albumList?[indexPath.row]
                let albumDetailsScreen = segue.destination as! AlbumDetailsScreen
                albumDetailsScreen.innerAlbum = selectedAlbum?.innerAlbum
            }
        }
    }
}

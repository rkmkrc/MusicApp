//
//  ArtistsScreen.swift
//  MusicApp
//
//  Created by Erkam Karaca on 9.05.2023.
//

import Foundation
import UIKit

class ArtistsScreen: UIViewController, UINavigationControllerDelegate, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    @IBOutlet weak var artistsCollectionView: UICollectionView!
    var urlComponents = URLComponents()
    var genre: Genre?
    var artistList: [Artist]? = [] {
        didSet {
            artistsCollectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = genre?.name
        setupCollectionView()
        initializeNetwork()
        getArtists()
    }
    
    func setupCollectionView() {
        artistsCollectionView.dataSource = self
        artistsCollectionView.delegate = self
        artistsCollectionView.register(UINib(nibName: "GenresCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "GenresCollectionViewCell")
    }
    
    func initializeNetwork() {
        let genreID = "/" + String(describing: self.genre?.id ?? 0)
        self.urlComponents.scheme = Network.scheme
        self.urlComponents.host = Network.host
        self.urlComponents.path = Network.genrePath + genreID + Network.artistsPath
        print(urlComponents)
    }
    
    func getArtists() {
        guard let url = URL(string: urlComponents.url?.absoluteString ?? "") else {
            print(MyError.URL_ERROR)
            return
        }
        
        fetchData(from: url, expecting: ArtistCollection.self) { result in
            switch result {
            case .success(let artists):
                DispatchQueue.main.async {
                    self.artistList = artists.data
                    self.artistsCollectionView.reloadData()
                }
            case .failure(let error):
                print(MyError.DATA_ERROR + " \(error)")
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.artistList?.count ?? Constants.DEFAULT_NUM_OF_CELLS
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let artist = artistList?[indexPath.row] {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GenresCollectionViewCell", for: indexPath) as! GenresCollectionViewCell
            cell.setupCell(item: artist)
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfItemsPerRow:CGFloat = Constants.NUMBER_OF_ITEMS_PER_ROW_GENRES
        let spacingBetweenCells:CGFloat = Constants.SPACING_FOR_GENRE_CELLS
        //Amount of total spacing in a row
        let totalSpacing = (2 * Constants.SPACING_FOR_GENRE_CELLS) + ((numberOfItemsPerRow - 1) * spacingBetweenCells)
        
        if let collectionView = self.artistsCollectionView{
            //Calculating width value for each row
            let width = (collectionView.bounds.width - totalSpacing)/numberOfItemsPerRow
            return CGSize(width: width, height: width * 1.25)
        }else{
            return CGSize(width: 0, height: 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "artistsToArtistDetails", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "artistsToArtistDetails" {
            if let indexPaths = artistsCollectionView.indexPathsForSelectedItems, let indexPath = indexPaths.first {
                let selectedArtist = artistList?[indexPath.row]
                let artistDetailsScreen = segue.destination as! ArtistDetailsScreen
                artistDetailsScreen.artist = selectedArtist
            }
        }
    }
}

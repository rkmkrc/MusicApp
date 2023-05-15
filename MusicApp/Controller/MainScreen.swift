//
//  MainScreen.swift
//  MusicApp
//
//  Created by Erkam Karaca on 8.05.2023.
//

import UIKit

class MainScreen: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UINavigationControllerDelegate {
    
    @IBOutlet weak var genresCollectionView: UICollectionView!
    var urlComponents = URLComponents()
    var genreList: [Genre]? = [] {
        didSet {
            genresCollectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = Constants.GENRES_TITLE
        setupCollectionView()
        initializeNetwork()
        getGenres()
        navigationController?.delegate = self
    }
    
    func setupCollectionView() {
        genresCollectionView.dataSource = self
        genresCollectionView.delegate = self
        genresCollectionView.register(UINib(nibName: "GenresCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "GenresCollectionViewCell")
    }
    
    func initializeNetwork() {
        self.urlComponents.scheme = Network.scheme
        self.urlComponents.host = Network.host
        self.urlComponents.path = Network.genrePath
        print(urlComponents)
    }
    
    func getGenres() {
        guard let url = URL(string: urlComponents.url?.absoluteString ?? "") else {
            print(MyError.URL_ERROR)
            return
        }
        
        fetchData(from: url, expecting: Genres.self) { result in
            switch result {
            case .success(let genres):
                DispatchQueue.main.async {
                    self.genreList = genres.data
                    self.genresCollectionView.reloadData()
                }
            case .failure(let error):
                print(MyError.DATA_ERROR + " \(error)")
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.genreList?.count ?? Constants.DEFAULT_NUM_OF_CELLS
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let genre = genreList?[indexPath.row] {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GenresCollectionViewCell", for: indexPath) as! GenresCollectionViewCell
            cell.setupCell(item: genre)
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "genresToArtists", sender: self)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfItemsPerRow:CGFloat = Constants.NUMBER_OF_ITEMS_PER_ROW_GENRES
        let spacingBetweenCells:CGFloat = Constants.SPACING_FOR_GENRE_CELLS
        //Amount of total spacing in a row
        let totalSpacing = (2 * Constants.SPACING_FOR_GENRE_CELLS) + ((numberOfItemsPerRow - 1) * spacingBetweenCells)
        
        if let collectionView = self.genresCollectionView{
            //Calculating width value for each row
            let width = (collectionView.bounds.width - totalSpacing)/numberOfItemsPerRow
            return CGSize(width: width, height: width)
        }else{
            return CGSize(width: 0, height: 0)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "genresToArtists" {
            if let indexPaths = genresCollectionView.indexPathsForSelectedItems, let indexPath = indexPaths.first {
                let selectedGenre = genreList?[indexPath.row]
                let artistsScreen = segue.destination as! ArtistsScreen
                artistsScreen.genre = selectedGenre
            }
        }
    }
}


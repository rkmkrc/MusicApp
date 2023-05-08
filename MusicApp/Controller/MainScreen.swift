//
//  MainScreen.swift
//  MusicApp
//
//  Created by Erkam Karaca on 8.05.2023.
//

import UIKit

class MainScreen: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var genresCollectionView: UICollectionView!
    var urlComponents = URLComponents()
    var genreList: [Genre]? = [] {
        didSet {
            genresCollectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        initializeNetwork()
        getGenres()
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
            print(MyError.UrlError)
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
                print(MyError.DataError + " \(error)")
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.genreList?.count ?? Constants.defaultNumberOfCells
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let genre = genreList?[indexPath.row] {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GenresCollectionViewCell", for: indexPath) as! GenresCollectionViewCell
            cell.setupCell(genre: genre)
            return cell
        }
        return UICollectionViewCell()
    }
}


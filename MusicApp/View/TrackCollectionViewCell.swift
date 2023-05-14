//
//  TrackCollectionViewCell.swift
//  MusicApp
//
//  Created by Erkam Karaca on 11.05.2023.
//

import UIKit

class TrackCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var trackDurationLabel: UILabel!
    @IBOutlet weak var trackNameLabel: UILabel!
    @IBOutlet weak var trackImageView: UIImageView!
    var favoriteManager = FavoriteManager()
    var track: Track?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupCell(innerAlbum: InnerAlbum?) {
        setupFavoriteButton(track: track)
        favoriteButton.setTitle("", for: .normal)
        trackNameLabel.text = track?.title
        if let duration = track?.duration {
            trackDurationLabel.text = secondsToMinutesAndSeconds(seconds: duration)
        }
        let imageUrl = URL(string: innerAlbum?.pictureLink ?? "")
        trackImageView.kf.setImage(with: imageUrl, placeholder: UIImage(named: "genrePlaceholderImage.png"), options: [.transition(.fade(0.2))], completionHandler: { result in
            switch result {
            case .success(_):
                break
            case .failure(_):
                self.trackImageView.image = UIImage(named: "genrePlaceholderImage.png")
                print(MyError.IMAGE_DOWNLOAD_ERROR)
                break
            }
        })
    }
    
    @IBAction func tapOnFavoriteButton(_ sender: UIButton) {
        if let track = self.track {
            if favoriteManager.isInFavorites(track: track) {
                favoriteManager.deleteFavoriteTrack(track: track)
                sender.tintColor = .systemGray
            } else {
                favoriteManager.addToFavorites(track: track)
                sender.tintColor = .red
            }
            NotificationCenter.default.post(name: Notification.Name("reloadTable"), object: nil)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.borderColor = UIColor.black.withAlphaComponent(0.3).cgColor
        layer.borderWidth = Constants.BORDER_WIDTH
        layer.cornerRadius = Constants.GENRE_CELL_RADIUS
        layer.masksToBounds = true
    }
    
    func setupFavoriteButton(track: Track?) {
        if let track = track {
            if favoriteManager.isInFavorites(track: track) {
                favoriteButton.tintColor = .red
            } else {
                favoriteButton.tintColor = .systemGray
            }
        }
    }
}

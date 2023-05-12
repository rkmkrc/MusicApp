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
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupCell(track: Track?, innerAlbum: InnerAlbum?) {
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.borderColor = UIColor.black.withAlphaComponent(0.3).cgColor
        layer.borderWidth = Constants.BORDER_WIDTH
        layer.cornerRadius = Constants.GENRE_CELL_RADIUS
        layer.masksToBounds = true
    }
}

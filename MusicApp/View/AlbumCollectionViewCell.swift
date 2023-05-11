//
//  AlbumCollectionViewCell.swift
//  MusicApp
//
//  Created by Erkam Karaca on 10.05.2023.
//

import UIKit
import Kingfisher

class AlbumCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var albumNameLabel: UILabel!
    @IBOutlet weak var albumReleaseDateLabel: UILabel!
    @IBOutlet weak var albumImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupCell(innerAlbum: InnerAlbum?) {
        albumNameLabel.text = innerAlbum?.title
        albumReleaseDateLabel.text = Constants.ALBUM_DATE
        let imageUrl = URL(string: innerAlbum?.pictureLink ?? "")
        albumImageView.kf.setImage(with: imageUrl, placeholder: UIImage(named: "genrePlaceholderImage.png"), options: [.transition(.fade(0.2))], completionHandler: { result in
            switch result {
            case .success(_):
                break
            case .failure(_):
                self.albumImageView.image = UIImage(named: "genrePlaceholderImage.png")
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

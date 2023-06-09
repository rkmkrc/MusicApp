//
//  GenresCollectionViewCell.swift
//  MusicApp
//
//  Created by Erkam Karaca on 8.05.2023.
//

import UIKit
import Kingfisher

class GenresCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var genreImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupCell(item: MyProtocol) {
        nameLabel.text = item.name
        let imageUrl = URL(string: item.pictureLink ?? "")
        genreImageView.kf.setImage(with: imageUrl, placeholder: UIImage(named: Constants.GENRE_PLACEHOLDER_IMAGE), options: [.transition(.fade(0.2))], completionHandler: { result in
            switch result {
            case .success(_):
                break
            case .failure(_):
                self.genreImageView.image = UIImage(named: Constants.PERSON_PLACEHOLDER_IMAGE)
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


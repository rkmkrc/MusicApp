//
//  GenresCollectionViewCell.swift
//  MusicApp
//
//  Created by Erkam Karaca on 8.05.2023.
//

import UIKit

class GenresCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupCell(genre: Genre?) {
        nameLabel.text = genre?.name
    }

}

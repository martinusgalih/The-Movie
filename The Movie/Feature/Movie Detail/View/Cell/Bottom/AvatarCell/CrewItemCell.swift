//
//  CrewItemCell.swift
//  The Movie
//
//  Created by Martinus Galih Widananto on 07/04/24.
//

import UIKit

class CrewItemCell: UICollectionViewCell {

    @IBOutlet var avatarImage: UIImageView! {
        didSet {
            avatarImage.layer.cornerRadius = 40
            avatarImage.clipsToBounds = true
        }
    }
    @IBOutlet var nameLabel: UILabel! {
        didSet {
            nameLabel.font = .poppins(size: 12.0, type: .regular)
            nameLabel.textColor = .init(hex: "#777777")
        }
    }
    
    func setupItem(crew: CastResponse) {
        nameLabel.text = crew.name
        if let url = crew.profilePath {
            avatarImage.source(url: MovieConstant.imageUrl + url)
        }
    }
}

//
//  HeaderCell.swift
//  The Movie
//
//  Created by Martinus Galih Widananto on 07/04/24.
//

import UIKit

protocol ImageHeaderCellProtocol {
    func didBackButtonTapped()
}

class ImageHeaderCell: UITableViewCell {
    
    @IBOutlet var transparentBackground: UIView!
    @IBOutlet var titleLabel: UILabel! {
        didSet {
            titleLabel.font = .poppins(size: 20.0, type: .bold)
            titleLabel.textColor = .init(hex: "#000000")
        }
    }
    @IBOutlet var hdIcon: UIImageView!
    @IBOutlet var genreLabel: UILabel! {
        didSet {
            genreLabel.font = .poppins(size: 12.0, type: .regular)
            genreLabel.textColor = .init(hex: "#777777")
        }
    }
    @IBOutlet var durationLabel: UILabel! {
        didSet {
            durationLabel.font = .poppins(size: 12.0, type: .regular)
            durationLabel.textColor = .init(hex: "#777777")
        }
    }
    @IBOutlet var movieImage: UIImageView! {
        didSet {
            movieImage.isUserInteractionEnabled = false
            movieImage.contentMode = .scaleAspectFill
        }
    }
    
    var delegate: ImageHeaderCellProtocol?
    
    func setupItem(_ item: MovieDetailResponse) {
        if let url = item.posterPath {
            movieImage.source(url: MovieConstant.imageUrl + url)
        }
        titleLabel.text = item.title
        genreLabel.text = item.genres.map({ $0.name }).joined(separator: ", ")
        durationLabel.text = item.runtime.description.convertMinutesToString()
        
        setupGradient()
    }
    
    func setupGradient() {
        if self.transparentBackground.layer.sublayers != nil {
            self.transparentBackground.layer.sublayers = nil
        }
        
        if self.movieImage.layer.sublayers != nil {
            self.movieImage.layer.sublayers = nil
        }
        transparentBackground.setGradientBackground(colorTop: .clear, colorMid: .white.withAlphaComponent(0.2), colorBottom: .white.withAlphaComponent(0.8), type: .vertical)
        movieImage.setGradientBackground(colorTop: .white.withAlphaComponent(0.4), colorMid: .clear, colorBottom: .clear, type: .vertical)
        
        contentView.layoutIfNeeded()
        layoutIfNeeded()
    }
    
    @IBAction func backBtnTapped(_ sender: Any) {
        delegate?.didBackButtonTapped()
    }
}

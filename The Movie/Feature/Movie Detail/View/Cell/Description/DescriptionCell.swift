//
//  DescriptionCell.swift
//  The Movie
//
//  Created by Martinus Galih Widananto on 07/04/24.
//

import UIKit

class DescriptionCell: UITableViewCell {
    @IBOutlet var descriptionLabel: UILabel! {
        didSet {
            descriptionLabel.font = .poppins(size: 12.0, type: .regular)
            descriptionLabel.textColor = .init(hex: "#777777")
            descriptionLabel.setLineSpacing(lineSpacing: 5)
        }
    }
}

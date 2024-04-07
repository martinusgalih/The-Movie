//
//  UIImageView+SDWebImage.swift
//  The Movie
//
//  Created by Martinus Galih Widananto on 06/04/24.
//

import UIKit
import SDWebImage

/**
 This is an extension of UIImageView to load image from url
    you can use this extension to load image from url like this
    ```
        let imageView = UIImageView()
        imageView.source(url: "https://image.tmdb.org/t/p/w500/kqjL17yufvn9OVLyXYpvtyrFfak.jpg")
    ```
 **/
extension UIImageView {
    func source(url: String, placeholder: String = "", placeHolderImage: UIImage? = nil, completion: ((_ image: UIImage?) -> Void)? = nil) {
        if let safeUrl = URL(string: url) {
            sd_setImage(with: safeUrl, placeholderImage: placeHolderImage, progress: nil, completed: {
                (image: UIImage?, error: Error?, cacheType: SDImageCacheType, imageURL: URL?) in
                completion?(image)
            })
        } else {
            image = UIImage(named: url)
        }
    }
}

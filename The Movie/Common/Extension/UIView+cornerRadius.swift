//
//  UIView+cornerRadius.swift
//  The Movie
//
//  Created by Martinus Galih Widananto on 07/04/24.
//

import UIKit

/**
 This is an extension of UIView to create corner radius
 you can use this extension to create corner radius like this
 ```
 let view = UIView()
 view.cornerRadius(radius: 10)
 ```
 **/
extension UIView {
    func cornerRadius(radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
}

//
//  UIView+gradient.swift
//  The Movie
//
//  Created by Martinus Galih Widananto on 07/04/24.
//

import UIKit

enum GradientType {
    case vertical
    case horizontal
}

/**
 This is an extension of UIView to create gradient background
 you can use this extension to create gradient background like this
 ```
 let view = UIView()
 view.setGradientBackground(colorTop: .red, colorMid: .green, colorBottom: .blue, type: .vertical)
 ```
 **/
extension UIView {
    func setGradientBackground(colorTop: UIColor, colorMid: UIColor, colorBottom: UIColor, type: GradientType ) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop.cgColor, colorMid.cgColor, colorMid.cgColor, colorBottom.cgColor]
        gradientLayer.locations = [0, 0.4, 0.75, 1]
        gradientLayer.frame = bounds
        if type == .vertical {
            gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
            gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        } else
        if type == .horizontal {
            gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        }

       layer.insertSublayer(gradientLayer, at: 0)
    }
}

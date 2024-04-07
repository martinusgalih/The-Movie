//
//  UIColor+hex.swift
//  The Movie
//
//  Created by Martinus Galih Widananto on 06/04/24.
//

import UIKit

/**
 This is an extension of UIColor to create UIColor from hex string
 you can use this extension to create UIColor from hex string like this
 ```
 let color = UIColor(hex: "#FFFFFF")
 ```
 **/
extension UIColor {
    convenience init?(hex: String, alpha: CGFloat = 1.0) {
        var formattedString = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if formattedString.hasPrefix("#") {
            formattedString.remove(at: formattedString.startIndex)
        }
        
        guard formattedString.count == 6 else {
            return nil
        }
        
        var rgbValue: UInt64 = 0
        Scanner(string: formattedString).scanHexInt64(&rgbValue)
        
        let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgbValue & 0x0000FF) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}

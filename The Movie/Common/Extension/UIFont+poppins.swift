//
//  UIFont+poppins.swift
//  The Movie
//
//  Created by Martinus Galih Widananto on 07/04/24.
//

import UIKit

/**
 This is an extension of UIFont to create UIFont from poppins font
 you can use this extension to create UIFont from poppins font like this
 ```
 let label = UILabel()
 label.font = UIFont.poppins(size: 16, type: .regular)
 ```
 **/
public enum PoppinsFontType: String {
    case regular = "-Regular"
    case medium = "-Medium"
    case bold = "-Bold"
    case light = "-Light"
}

extension UIFont {
    static func poppins(size: CGFloat, type: PoppinsFontType) -> UIFont {
        return UIFont(name: "Poppins\(type.rawValue)", size: size) ?? UIFont.systemFont(ofSize: size)
    }
}

extension UILabel {
    func setLineSpacing(lineSpacing: CGFloat) {
        guard let labelText = self.text else { return }

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        
        let attributedString = NSMutableAttributedString(string: labelText)
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedString.length))
        
        self.attributedText = attributedString
    }
}

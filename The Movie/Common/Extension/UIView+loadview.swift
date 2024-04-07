//
//  UIView+loadview.swift
//  The Movie
//
//  Created by Martinus Galih Widananto on 07/04/24.
//

import UIKit

extension UIView {
    /**
     This is an extension of UIView to get view loading action
     you can use this extension to  like this
     ```
     view.loading(on: true)
     }
     ```
     **/
    static let UIViewLoadingTag = -1234567890121
    func loading(on: Bool, style: UIActivityIndicatorView.Style = .medium) -> Void {
        UIApplication.topViewController()?.navigationController?.interactivePopGestureRecognizer?.isEnabled = !on
        if on == true {
            for subview in self.subviews {
                if subview.tag == UIView.UIViewLoadingTag {
                    (subview as! UIActivityIndicatorView).stopAnimating()
                    subview.removeFromSuperview()
                }
            }
            let indicatorView = UIActivityIndicatorView(style: style)
            indicatorView.tag = UIView.UIViewLoadingTag
            indicatorView.backgroundColor = .gray.withAlphaComponent(0.5)
            indicatorView.frame = CGRect(x: 0.0, y: 0.0, width: self.frame.size.width, height: self.frame.size.height)
            indicatorView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            indicatorView.startAnimating()
            self.addSubview(indicatorView)
        } else {
            for subview in self.subviews {
                if subview.tag == UIView.UIViewLoadingTag {
                    (subview as! UIActivityIndicatorView).stopAnimating()
                    subview.removeFromSuperview()
                }
            }
        }
    }
}

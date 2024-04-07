//
//  UIApplication+topViewController.swift
//  The Movie
//
//  Created by Martinus Galih Widananto on 06/04/24.
//

import UIKit

/**
 This is an extension of UIApplication to get top view controller
 you can use this extension to get top view controller like this
 ```
 if let topVC = UIApplication.topViewController() {
 topVC.present(alert, animated: true)
 }
 ```
 **/
extension UIApplication {
    class func topViewController(_ base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(nav.visibleViewController)
        }
        
        if let tab = base as? UITabBarController {
            let moreNavigationController = tab.moreNavigationController
            
            if let top = moreNavigationController.topViewController, top.view.window != nil {
                return topViewController(top)
            } else if let selected = tab.selectedViewController {
                return topViewController(selected)
            }
        }
        
        if let presented = base?.presentedViewController {
            return topViewController(presented)
        }
        
        return base
    }
}

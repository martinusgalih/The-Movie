//
//  SnackBar.swift
//  The Movie
//
//  Created by Martinus Galih Widananto on 07/04/24.
//

import UIKit

/**
 This is SnackBar Component that will show a message on the bottom of the screen
 You can show a message by calling showSnackbar method
 **/

class SnackbarManager {
    static let shared = SnackbarManager()
    
    private var isSnackbarVisible = false
    
    private init() {}
    
    func showSnackbar(message: String, viewController: UIViewController) {
        guard !isSnackbarVisible else {
            return
        }
        self.isSnackbarVisible = true
        let snackbarView = UIView(frame: CGRect(x: 0, y: viewController.view.frame.maxY - 100, width: viewController.view.frame.width, height: 50))
        snackbarView.backgroundColor = .red
        
        let label = UILabel(frame: snackbarView.bounds)
        label.text = message
        label.textColor = .white
        label.textAlignment = .center
        snackbarView.addSubview(label)
        
        viewController.view.addSubview(snackbarView)
        UIView.animate(withDuration: 0.5, animations: {
            snackbarView.frame.origin.y -= snackbarView.frame.height - 50
        }) { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                UIView.animate(withDuration: 0.5, animations: {
                    snackbarView.frame.origin.y += snackbarView.frame.height
                }) { _ in
                    snackbarView.removeFromSuperview()
                    self.isSnackbarVisible = false
                }
            }
        }
    }
}

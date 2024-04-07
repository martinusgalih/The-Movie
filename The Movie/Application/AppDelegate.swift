//
//  AppDelegate.swift
//  The Movie
//
//  Created by Martinus Galih Widananto on 04/04/24.
//

import UIKit
import netfox
import Foundation

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var navigationController: UINavigationController?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        NFX.sharedInstance().start()
        
        setRootViewController()
        return true
    }
    
    func setRootViewController() {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.navigationController = UINavigationController()
        self.navigationController?.view.backgroundColor = UIColor.white
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.window?.rootViewController = self.navigationController
        self.window?.makeKeyAndVisible()
        
        self.navigationController?.pushViewController(ListMovieViewController(), animated: true)
    }
}

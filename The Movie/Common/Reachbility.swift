//
//  Reachbility.swift
//  The Movie
//
//  Created by Martinus Galih Widananto on 07/04/24.
//

import Foundation
import SystemConfiguration

/**
 This is a class to check internet connection
 you can use this class to check internet connection like this
 ```
    if Reachability.isConnectedToNetwork() {
        print("Internet connection available")
    } else {
        print("Internet connection not available")
    }
 
 ```
 */
class Reachability {
    static func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return false
        }
        
        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        return (isReachable && !needsConnection)
    }
}

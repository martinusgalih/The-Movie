//
//  DataRequest.swift
//  The Movie
//
//  Created by Martinus Galih Widananto on 05/04/24.
//

import Foundation

public enum HTTPMethodType: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

public protocol DataRequest{
    var url: String { get }
    var method: HTTPMethodType { get }
    var headers: [String : String] { get }
    var queryItems: [String : String] { get }
}

extension DataRequest {
    var headers: [String : String] {
        [:]
    }
    
    var queryItems: [String : String] {
        [:]
    }
}


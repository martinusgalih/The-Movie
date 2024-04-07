//
//  LocalStorage.swift
//  The Movie
//
//  Created by Martinus Galih Widananto on 07/04/24.
//

import Foundation
import RxSwift

/**
 This is a singleton class that is responsible for caching and retrieving data from UserDefaults.
 How to use:
 1. Call the `cacheResponse` method to cache the response.
 2. Call the `getCachedResponse` method to get the cached response.
 **/
struct LocalStorage {
    static let shared = LocalStorage()
    
    private init() {}
    
    func cacheResponse<T: Encodable>(_ response: T, forKey key: String) {
        do {
            let encodedData = try JSONEncoder().encode(response)
            UserDefaults.standard.set(encodedData, forKey: key)
        } catch {
            print("Error caching response for key \(key): \(error)")
        }
    }
    
    func getCachedResponse<T: Decodable>(forKey key: String) -> Observable<T?> {
        return Observable.create { observer in
            if let cachedData = UserDefaults.standard.data(forKey: key),
               let cachedResponse = try? JSONDecoder().decode(T.self, from: cachedData) {
                observer.onNext(cachedResponse)
            }
            observer.onCompleted()
            return Disposables.create()
        }
    }
    
    func getCachedResponse<T: Decodable>(forKey key: String) -> T? {
         if let cachedData = UserDefaults.standard.data(forKey: key),
            let cachedResponse = try? JSONDecoder().decode(T.self, from: cachedData) {
             return cachedResponse
         }
         return nil
     }
}


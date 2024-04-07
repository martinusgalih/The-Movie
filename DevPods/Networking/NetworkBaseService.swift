//
//  NetworkBaseService.swift
//  Networking
//
//  Created by Martinus Galih Widananto on 05/04/24.
//

import RxSwift

public final class NetworkBaseRequestService<T: Decodable> {
    public func fetch<U: Decodable>(dataRequest: any DataRequest) -> Observable<U> {
        return Observable.create { observer in
            let networkRequest = NetworkRequest(url: dataRequest.url, method: dataRequest.method, headers: dataRequest.headers, queryItems: dataRequest.queryItems)
            networkRequest.request { (result: Result<NetworkRequest.Response, Error>) in
                switch result {
                case .success(let data):
                    observer.onNext(data as! U)
                    observer.onCompleted()
                case .failure(let error):
                    observer.onError(error)
                }
            }
            
            return Disposables.create {
                networkRequest.cancel()
            }
        }
    }
}

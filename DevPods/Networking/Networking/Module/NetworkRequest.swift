//
//  NetworkService.swift
//  The Movie
//
//  Created by Martinus Galih Widananto on 05/04/24.
//

import RxSwift

enum ErrorResponse: String {
    case invalidEndpoint = "Invalid endpoint"
}

public final class NetworkRequest<T: Decodable> {
    public typealias Response = T
    
    private var task: URLSessionDataTask?
    private var url: String
    private var method: HTTPMethodType
    private var headers: [String : String]
    private var queryItems: [String : String]
    
    public init(data: DataRequest) {
        self.url = data.url
        self.method = data.method
        self.headers = data.headers
        self.queryItems = data.queryItems
    }
    
    public func decode(_ data: Data) throws -> T {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            print("Failed to decode data: \(error)")
            throw error
        }
    }
    
    public func request(completion: @escaping (Result<Response, Error>) -> Void) {
        guard let url = generateURL() else {
            let error = NSError(
                domain: ErrorResponse.invalidEndpoint.rawValue,
                code: 404,
                userInfo: nil
            )
            completion(.failure(error))
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        urlRequest.allHTTPHeaderFields = headers
        
        task = URLSession.shared.dataTask(with: urlRequest) { [weak self] (data, response, error) in
            guard let self = self else { return }
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let response = response as? HTTPURLResponse, 200..<300 ~= response.statusCode else {
                let error = NSError(
                    domain: ErrorResponse.invalidEndpoint.rawValue,
                    code: 404,
                    userInfo: nil
                )
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                let error = NSError(
                    domain: ErrorResponse.invalidEndpoint.rawValue,
                    code: 404,
                    userInfo: nil
                )
                completion(.failure(error))
                return
            }
            
            do {
                let decodedData = try self.decode(data)
                completion(.success(decodedData))
            } catch {
                completion(.failure(error))
            }
        }
        
        task?.resume()
    }
    
    public func cancel() {
        task?.cancel()
    }
    
    public func generateURL() -> URL? {
        guard var urlComponent = URLComponents(string: url) else {
            return nil
        }
        
        var queryItems: [URLQueryItem] = []
        self.queryItems.forEach {
            let urlQueryItem = URLQueryItem(name: $0.key, value: $0.value)
            urlComponent.queryItems?.append(urlQueryItem)
            queryItems.append(urlQueryItem)
        }
        if !queryItems.isEmpty {
            urlComponent.queryItems = queryItems
        }
        return urlComponent.url
    }
}

public final class NetworkBaseService<T: Decodable> {
    public init() {}
    public func fetch(dataRequest: DataRequest) -> Observable<T> {
        let networkRequest = NetworkRequest<T>(data: dataRequest)
        let observable = Observable<T>.create { observer in
            networkRequest.request { result in
                switch result {
                case .success(let data):
                    observer.onNext(data)
                    observer.onCompleted()
                case .failure(let error):
                    observer.onError(error)
                }
            }
            
            return Disposables.create {
                networkRequest.cancel()
            }
        }
        return observable
    }
    
    public func requestDisposable(dataRequest: DataRequest) -> Disposable {
        let networkRequest = NetworkRequest<T>(data: dataRequest)
        return Disposables.create {
            networkRequest.cancel()
        }
    }
}

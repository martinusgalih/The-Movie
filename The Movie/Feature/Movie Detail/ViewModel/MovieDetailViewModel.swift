//
//  MovieDetailViewModel.swift
//  The Movie
//
//  Created by Martinus Galih Widananto on 07/04/24.
//

import Foundation
import RxSwift

class MovieDetailViewModel: ViewModelProtocol {
    private let movieApiService: MovieApiServiceProtocol
    private var currentPage: Int = 1
    private let disposeBag = DisposeBag()
    
    internal var alert: UIAlertController?
    var movieDetailItem: MovieDetailResponse?
    var isLoading: BehaviorSubject<Bool> = .init(value: false)
    var id: Int = 0
    init(movieApiService: MovieApiServiceProtocol = MovieAPIServices()) {
        self.movieApiService = movieApiService
    }
    
    func onViewDidLoad() {
        getLocalDetailMovieData()
        fetchDetailMovie(id: id)
    }
    
    /**
     Check if there is any cached data in local storage, if there is, then fetch the data from local storage, if not, then fetch the data from the API
     **/
    func getLocalDetailMovieData() {
        LocalStorage.shared.getCachedResponse(forKey: "MovieDetailResponse_\(id)")
            .subscribe(onNext: { [weak self] (cachedResponse: MovieDetailResponse?) in
                guard let self = self, let cachedResponse = cachedResponse else { return }
                self.isLoading.onNext(false)
                self.movieDetailItem = cachedResponse
            })
            .disposed(by: disposeBag)
    }
    
    func fetchDetailMovie(id: Int) {
        isLoading.onNext(true)
        
        movieApiService.fetchMovieDetail(id: id.description)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] response in
                guard let self else { return }
                self.isLoading.onNext(false)
                self.movieDetailItem = response
                LocalStorage.shared.cacheResponse(response, forKey: "MovieDetailResponse_\(id)")
                print(response)
            }, onError: { [weak self] error in
                guard let self else { return }
                self.isLoading.onNext(false)
                self.alertError(message: error.localizedDescription)
                print(error)
            }).disposed(by: disposeBag)
    }
    
    func refreshData() {
        fetchDetailMovie(id: id)
    }
}

extension MovieDetailViewModel {
    func alertError(title: String = "Error", message: String) {
        guard let topViewController = UIApplication.topViewController() else { return }
        alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: { [weak self] _ in
            self?.alert = nil
        })
        alert?.addAction(okAction)
        if let alert {
            topViewController.present(alert, animated: true, completion: nil)
        }
    }
}

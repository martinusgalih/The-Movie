//
//  ListMovieViewModel.swift
//  The Movie
//
//  Created by Martinus Galih Widananto on 06/04/24.
//

import Foundation
import RxSwift

protocol ViewModelProtocol {
    var isLoading: BehaviorSubject<Bool> { get }
    var alert: UIAlertController? { get set }
    func alertError(title: String, message: String)
    func onViewDidLoad()
}

protocol RefreshViewModel {
    func refreshData()
}

class ListMovieViewModel: ViewModelProtocol, RefreshViewModel{
    private let movieApiService: MovieApiServiceProtocol
    private var currentPage: Int = 1
    private let disposeBag = DisposeBag()
    
    internal var alert: UIAlertController?
    var recentSearch: String = ""
    var isSearchActive: Bool = false
    var isReachBottom: Bool = false
    var isRefresh: Bool = false
    var items: [MovieResponse] = []
    var movieList: BehaviorSubject<[MovieResponse]> = .init(value: [])
    var isLoading: BehaviorSubject<Bool> = .init(value: false)
    init(movieApiService: MovieApiServiceProtocol = MovieAPIServices()) {
        self.movieApiService = movieApiService
    }
    
    func onViewDidLoad() {
        getLocalGenreData()
    }
    
    /**
     Check if there is any cached data in local storage, if there is, then fetch the data from local storage, if not, then fetch the data from the API
     **/
    func getLocalGenreData() {
        if let cachedResponse: AllGenreResponse = LocalStorage.shared.getCachedResponse(forKey: "MovieAllGenreResponse") {
            getMovies()
        } else {
            getAllGenreMovie()
        }
    }
    
    /**
     Check if the user is connected to the internet, if connected, then fetch the data from the API, if not, then fetch the data from local storage
     **/
    func getMovies() {
        if Reachability.isConnectedToNetwork() {
            fetchPopularMovie()
        } else {
            alertError(title: "Offline", message: "Seems like you're offline. Data will be retrieved from your last loaded session.")
            getLocalPopularMovieData()
        }
    }
    
    func getAllGenreMovie() {
        if Reachability.isConnectedToNetwork() {
            isLoading.onNext(true)
            movieApiService.fetchGenres()
                .observe(on: MainScheduler.instance)
                .subscribe(onNext: { [weak self] response in
                    guard let self else { return }
                    LocalStorage.shared.cacheResponse(response, forKey: "MovieAllGenreResponse")
                    getMovies()
                }, onError: { [weak self] error in
                    guard let self else { return }
                    self.alertError(message: error.localizedDescription)
                }).disposed(by: disposeBag)
        } else {
            alertError(title: "Offline", message: "Seems like you're offline. Data will be retrieved from your last loaded session.")
            getLocalPopularMovieData()
        }
    }
    
    func onPagination() {
        if Reachability.isConnectedToNetwork() {
            if self.isSearchActive {
                self.searchMovie(query: recentSearch)
            } else {
                self.fetchPopularMovie()
            }
        } else {
            getLocalPopularMovieData()
        }
    }
    
    func getLocalPopularMovieData() {
        LocalStorage.shared.getCachedResponse(forKey: "MovieListResponse")
            .subscribe(onNext: { [weak self] (cachedResponse: MovieListResponse?) in
                guard let self = self, let cachedResponse = cachedResponse else { return }
                self.isLoading.onNext(false)
                self.appendItem(cachedResponse.results, self.isRefresh)
                self.currentPage += 1
            })
            .disposed(by: disposeBag)
    }
    
    func fetchPopularMovie(isRefresh: Bool = false) {
        isLoading.onNext(true)
        movieApiService.fetchPopularMovies(page: currentPage)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] response in
                guard let self else { return }
                self.isLoading.onNext(false)
                self.appendItem(response.results, isRefresh)
                LocalStorage.shared.cacheResponse(response, forKey: "MovieListResponse")
                print(response)
            }, onError: { [weak self] error in
                guard let self else { return }
                self.isLoading.onNext(false)
                self.alertError(message: error.localizedDescription)
                print(error)
            }).disposed(by: disposeBag)
    }
    
    func searchMovie(query: String, isRefresh: Bool = false) {
        recentSearch = query
        isLoading.onNext(true)
        movieApiService.searchMovies(query: query, page: currentPage)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] response in
                guard let self else { return }
                self.isLoading.onNext(false)
                self.appendItem(response.results, isRefresh)
            }, onError: { [weak self] error in
                guard let self else { return }
                self.isLoading.onNext(false)
                self.alertError(message: error.localizedDescription)
            }).disposed(by: disposeBag)
    }
    
    func appendItem(_ response: [MovieResponse],_ isRefresh: Bool) {
        if isRefresh {
            self.isRefresh = false
            movieList.onNext(response)
            return
        }
        var currentMovies: [MovieResponse] = []
        if let currentData = try? movieList.value() {
            currentMovies.append(contentsOf: currentData)
        }
        currentMovies.append(contentsOf: response)
        items = currentMovies
        movieList.onNext(currentMovies)
        currentPage += 1
        
        if response.isEmpty && !currentMovies.isEmpty {
            guard let topViewController = UIApplication.topViewController() else { return }
            SnackbarManager.shared.showSnackbar(message: "You have reached the bottom", viewController: topViewController)
            isReachBottom = true
        }
    }
    
    func refreshData() {
        isRefresh = true
        resetPage()
        currentPage = 1
        isReachBottom = false
        if isSearchActive {
            searchMovie(query: recentSearch, isRefresh: true)
        } else {
            fetchPopularMovie(isRefresh: true)
        }
    }
    
    func resetPage() {
        DispatchQueue.main.async {
            self.movieList.onNext([])
            self.currentPage = 1
            self.isReachBottom = false
        }
    }
}

extension ListMovieViewModel {
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

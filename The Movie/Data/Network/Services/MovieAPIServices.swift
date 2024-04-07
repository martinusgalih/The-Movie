//
//  MovieAPIServices.swift
//  The Movie
//
//  Created by Martinus Galih Widananto on 06/04/24.
//

import Foundation
import RxSwift
import Networking

protocol MovieApiServiceProtocol {
    func fetchPopularMovies(page: Int)-> Observable<MovieListResponse>
    func searchMovies(query: String, page: Int) -> Observable<MovieListResponse>
    func fetchMovieDetail(id: String) -> Observable<MovieDetailResponse>
    func fetchGenres() -> Observable<AllGenreResponse>
}

class MovieAPIServices: MovieApiServiceProtocol {
    /**
     Fetch popular movie with page parameter
     **/
    func fetchPopularMovies(page: Int)-> Observable<MovieListResponse> {
        let service = NetworkBaseService<MovieListResponse>()
        return service.fetch(dataRequest: MovieAPIRouter.fetchPopularMovies(page: page))
    }
    
    /**
     Search  movie with query character and page parameter
     **/
    func searchMovies(query: String, page: Int) -> Observable<MovieListResponse> {
        let service = NetworkBaseService<MovieListResponse>()
        return service.fetch(dataRequest: MovieAPIRouter.searchMovies(query: query, page: page))
    }
    
    /**
     Fetch  movie detail with id parameter
     **/
    func fetchMovieDetail(id: String) -> Observable<MovieDetailResponse> {
        let service = NetworkBaseService<MovieDetailResponse>()
        return service.fetch(dataRequest: MovieAPIRouter.fetchMovieDetail(id: id))
    }
    
    /**
     Fetch  movie genres 
     **/
    func fetchGenres() -> Observable<AllGenreResponse> {
        let service = NetworkBaseService<AllGenreResponse>()
        return service.fetch(dataRequest: MovieAPIRouter.fetchGenres)
    }
}

//
//  MovieAPIRouter.swift
//  The Movie
//
//  Created by Martinus Galih Widananto on 06/04/24.
//

import Foundation
import Networking

enum MovieAPIRouter {
    case fetchPopularMovies(page: Int)
    case searchMovies(query: String, page: Int)
    case fetchMovieDetail(id: String)
    case fetchGenres
}

/**
 Movie API Constant based on TMDB web
 imageUrl: https://developer.themoviedb.org/docs/image-basics
 apiUrl and other documentation: https://developer.themoviedb.org/reference/movie-popular-list
 apiKey: get from login auth when you have account in TMDB
 **/
struct MovieConstant {
    static let imageUrl: String = "https://image.tmdb.org/t/p/original/"
    static let apiUrl: String = "https://api.themoviedb.org/3/"
    static let apiKey: String = "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJjM2E5YzBiZDFlNThkYzAxZTVmZTIyZDU0ZDhkYzgxMSIsInN1YiI6IjY2MGVkMzU5YTg4NTg3MDE3Y2VhMGY3YSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.4qjYd13WmnNptXM2HMO_qDd8fZkQIiXeZyrNp-YjPT0"
}

/**
 This is API router extended from MovieAPIRouter enum and DataRequest protocol
 You can create other API with same method
 **/
extension MovieAPIRouter: DataRequest {
    var url: String {
        switch self {
            case .fetchPopularMovies:
                return "\(MovieConstant.apiUrl)movie/popular"
            case .searchMovies:
                return "\(MovieConstant.apiUrl)search/movie"
            case .fetchMovieDetail(let query):
                return "\(MovieConstant.apiUrl)movie/\(query)"
            case .fetchGenres:
                return "\(MovieConstant.apiUrl)genre/movie/list"
        }
    }
    
    var method: Networking.HTTPMethodType {
        .get
    }
    
    var headers: [String : String] {
        return ["accept": "application/json",
                "Authorization": "Bearer" + " \(MovieConstant.apiKey)"]
    }
    
    var queryItems: [String : String] {
        switch self {
            case .fetchPopularMovies(let page):
                return ["page" : page.description,
                        "language" : "en-US"]
            case .searchMovies(let query, let page):
                return ["query" : query,
                        "page" : page.description,
                        "include_adult" : "true",
                        "language" : "en-US"]
            case .fetchGenres:
                return ["language" : "en"]
            case  .fetchMovieDetail:
                return ["append_to_response": "credits"]
        }
    }
}

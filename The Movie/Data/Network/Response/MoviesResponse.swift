//
//  MoviesResponse.swift
//  The Movie
//
//  Created by Martinus Galih Widananto on 06/04/24.
//

import Foundation

struct MovieListResponse: Codable {
    let page: Int
    let results: [MovieResponse]
    let totalPages: Int
    let totalResults: Int
}

struct MovieResponse: Codable {
    let backdropPath: String?
    let genreIds: [Int]?
    let id: Int
    let originalLanguage: String
    let originalTitle: String
    let overview: String
    let popularity: Double
    let posterPath: String?
    let releaseDate: String
    let title: String
    let video: Bool
    let voteAverage: Double
    let voteCount: Int
}

struct MovieDetailResponse: Codable {
    let adult: Bool
    let backdropPath: String?
    let budget: Int
    let genres: [GenreResponse]
    let homepage: String?
    let id: Int
    let imdbId: String?
    let originalLanguage: String
    let originalTitle: String
    let overview: String
    let popularity: Double
    let posterPath: String?
    let releaseDate: String
    let revenue: Int
    let runtime: Int
    let status: String
    let tagline: String?
    let title: String
    let video: Bool
    let voteAverage: Double
    let voteCount: Int
    let credits: CreditsResponse
}

struct GenreResponse: Codable {
    let id: Int
    let name: String
}

struct CreditsResponse: Codable {
    let cast, crew: [CastResponse]
}

struct CastResponse: Codable {
    let adult: Bool
    let gender, id: Int
    let knownForDepartment: String
    let name, originalName: String
    let popularity: Double
    let profilePath: String?
    let castID: Int?
    let character: String?
    let creditId: String
    let order: Int?
    let department: String?
    let job: String?
}

struct AllGenreResponse: Codable{
    let genres: [GenreResponse]
}

//
//  MovieListWelcome.swift
//  MovieClip
//
//  Created by 권정근 on 2/18/25.
//

import Foundation

// MARK: - MovieListWelcome
struct MovieListWelcome: Codable {
    let dates: MovieListDates
    let page: Int
    let results: [MovieListResult]
    let totalPages, totalResults: Int

    enum CodingKeys: String, CodingKey {
        case dates, page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}


// MARK: - MovieListDates
struct MovieListDates: Codable {
    let maximum, minimum: String
}


// MARK: - MovieListResult
struct MovieListResult: Codable {
    let adult: Bool
    let backdropPath: String
    let genreIDS: [Int]
    let id: Int
    let originalTitle, overview: String
    let popularity: Double
    let posterPath, releaseDate, title: String
    let video: Bool
    let voteAverage: Double
    let voteCount: Int

    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case genreIDS = "genre_ids"
        case id
        case originalTitle = "original_title"
        case overview, popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title, video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}

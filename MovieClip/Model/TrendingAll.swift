//
//  TrendingAll.swift
//  MovieClip
//
//  Created by 권정근 on 2/7/25.
//

import Foundation


// MARK: - AllWelcome
struct AllWelcome: Codable {
    let page: Int
    let results: [AllResult]
    let totalPages, totalResults: Int

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

// MARK: - AllResult
struct AllResult: Codable {
    let backdropPath: String?
    let id: Int
    let title, originalTitle: String?
    let overview, posterPath: String
    let mediaType: AllMediaType
    let adult: Bool
    let originalLanguage: String
    let genreIDS: [Int]
    let popularity: Double
    let releaseDate: String?
    let video: Bool?
    let voteAverage: Double
    let voteCount: Int
    let name, originalName, firstAirDate: String?
    let originCountry: [String]?

    enum CodingKeys: String, CodingKey {
        case backdropPath = "backdrop_path"
        case id, title
        case originalTitle = "original_title"
        case overview
        case posterPath = "poster_path"
        case mediaType = "media_type"
        case adult
        case originalLanguage = "original_language"
        case genreIDS = "genre_ids"
        case popularity
        case releaseDate = "release_date"
        case video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case name
        case originalName = "original_name"
        case firstAirDate = "first_air_date"
        case originCountry = "origin_country"
    }
}

enum AllMediaType: String, Codable {
    case movie = "movie"
    case tv = "tv"
}

//
//  TrendingTVs.swift
//  MovieClip
//
//  Created by 권정근 on 2/6/25.
//

import Foundation

// MARK: - TVWelcome
struct TVWelcome: Codable {
    let page: Int
    let results: [TVResult]
    let totalPages, totalResults: Int

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

// MARK: - TVResult
struct TVResult: Codable {
    let backdropPath: String?
    let id: Int
    let name, originalName, overview, posterPath: String
    let mediaType: TVMediaType
    let adult: Bool
    let originalLanguage: String
    let genreIDS: [Int]
    let popularity: Double
    let firstAirDate: String
    let voteAverage: Double
    let voteCount: Int
    let originCountry: [String]
    var genreNames: [String]?    // 장르 이름을 저장하는 필드 추가

    enum CodingKeys: String, CodingKey {
        case backdropPath = "backdrop_path"
        case id, name
        case originalName = "original_name"
        case overview
        case posterPath = "poster_path"
        case mediaType = "media_type"
        case adult
        case originalLanguage = "original_language"
        case genreIDS = "genre_ids"
        case popularity
        case firstAirDate = "first_air_date"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case originCountry = "origin_country"
    }
}

enum TVMediaType: String, Codable {
    case tv = "tv"
}

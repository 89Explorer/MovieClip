//
//  SearchResultMedia.swift
//  MovieClip
//
//  Created by 권정근 on 2/21/25.
//

import Foundation


// MARK: - SearchResultMedia - 영화
struct SearchResultMedia: Codable, Hashable {
    let page: Int
    let results: [MediaResult]
    let totalPages, totalResults: Int

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

// MARK: - MediaResult
struct MediaResult: Codable, Hashable {
    let adult: Bool
    let backdropPath: String?
    let genreIDS: [Int]
    let id: Int
    let originalTitle, overview: String?
    let name: String?
    let popularity: Double
    let title: String?
    let releaseDate: String?
    let posterPath: String?
    let video: Bool?
    let voteAverage: Double
    let voteCount: Int
    var genreNames: [String]?

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
        case name
    }
}


enum SearchSection: Hashable, CaseIterable {
    case movie
    case tv
    case people
}

enum SearchItem: Hashable {
    case movie(MediaResult)
    case tv(MediaResult)
    case people(PersonResult)
}

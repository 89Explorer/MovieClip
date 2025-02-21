//
//  SearchResultPerson.swift
//  MovieClip
//
//  Created by 권정근 on 2/21/25.
//

import Foundation


// MARK: - Welcome
struct SearchResultPerson: Codable {
    let page: Int
    let results: [PerosnResult]
    let totalPages, totalResults: Int

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

// MARK: - Result
struct PerosnResult: Codable {
    let adult: Bool
    let gender, id: Int
    let knownForDepartment: PersonKnownForDepartment?
    let name, originalName: String
    let popularity: Double
    let profilePath: String?
    let knownFor: [PersonKnownFor]

    enum CodingKeys: String, CodingKey {
        case adult, gender, id
        case knownForDepartment = "known_for_department"
        case name
        case originalName = "original_name"
        case popularity
        case profilePath = "profile_path"
        case knownFor = "known_for"
    }
}

// MARK: - KnownFor
struct PersonKnownFor: Codable {
    let backdropPath: String?
    let id: Int
    let title, originalTitle: String?
    let overview: String
    let posterPath: String?
    let mediaType: PersonMediaType
    let adult: Bool
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

enum PersonMediaType: String, Codable {
    case movie = "movie"
    case tv = "tv"
}

enum PersonKnownForDepartment: String, Codable {
    case acting = "Acting"
    case production = "Production"
    case writing = "Writing"
    case directing = "Directing"
    case creator = "Creator"
    case camera = "Camera"
    case unknown  // ✅ 새로운 값이 들어오면 기본적으로 unknown 처리

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let value = try? container.decode(String.self)
        self = PersonKnownForDepartment(rawValue: value ?? "") ?? .unknown
    }
}

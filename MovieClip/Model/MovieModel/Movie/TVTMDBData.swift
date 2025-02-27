//
//  TVTMDBData.swift
//  MovieClip
//
//  Created by 권정근 on 2/19/25.
//

import Foundation


// MARK: - TVCombineData
struct TvCombineData: Codable, Hashable {
    var combineTMDB: [TvTMDBData]
}


// MARK: - TVTMDBData
struct TvTMDBData: Codable, Hashable {
    var page: Int
    var results: [TvTMDBResult]
    var totalPages, totalResults: Int
    var type: TvSectionType?

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
        case type
    }
}

// MARK: - Result
struct TvTMDBResult: Codable, Hashable {
    let adult: Bool
    let backdropPath: String?
    let genreIDS: [Int]
    let id: Int
    let originCountry: [String]
    let originalLanguage, originalName, overview: String
    let popularity: Double
    let posterPath, firstAirDate, name: String
    let voteAverage: Double
    let voteCount: Int
    var genreNames: [String]?

    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case genreIDS = "genre_ids"
        case id
        case originCountry = "origin_country"
        case originalLanguage = "original_language"
        case originalName = "original_name"
        case overview, popularity
        case posterPath = "poster_path"
        case firstAirDate = "first_air_date"
        case name
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}


enum TvSectionType: String, Codable {
    case airingToday = "Air Today"
    case onTheAir = "On The Air"
    case popular = "Popular"
    case topRated = "TopRated"
}


struct TvResultItem: Hashable {
    let tvResult: TvTMDBResult
    let sectionType: TvSectionType

    func hash(into hasher: inout Hasher) {
        // tvResult.id와 sectionType을 조합해서 고유 해시 생성
        hasher.combine(tvResult.id)
        hasher.combine(sectionType)
    }
    
    static func == (lhs: TvResultItem, rhs: TvResultItem) -> Bool {
        return lhs.tvResult.id == rhs.tvResult.id &&
               lhs.sectionType == rhs.sectionType
    }
}

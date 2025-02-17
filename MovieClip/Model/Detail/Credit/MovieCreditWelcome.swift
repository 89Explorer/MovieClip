//
//  MovieCreditWelcome.swift
//  MovieClip
//
//  Created by 권정근 on 2/17/25.
//

import Foundation


// MARK: - MovieCreditWelcome
struct MovieCreditWelcome: Codable {
    let cast, crew: [MovieCreditCast]
    let id: Int
}

// MARK: - MovieCreditCast
struct MovieCreditCast: Codable {
    let adult: Bool
    let backdropPath: String?
    let genreIDS: [Int]
    let id: Int
    let originalTitle, overview: String
    let popularity: Double
    let posterPath: String?
    let releaseDate, title: String
    let video: Bool
    let voteAverage: Double
    let voteCount: Int
    let character: String?
    let creditID: String
    let order: Int?
    let department, job: String?

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
        case character
        case creditID = "credit_id"
        case order, department, job
    }
}



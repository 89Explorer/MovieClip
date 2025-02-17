//
//  TVCreditWelcome.swift
//  MovieClip
//
//  Created by 권정근 on 2/17/25.
//

import Foundation


// MARK: - TVCreditWelcome
struct TVCreditWelcome: Codable {
    let cast, crew: [TVCreditCast]
    let id: Int
}

// MARK: - TVCreditCast
struct TVCreditCast: Codable {
    let adult: Bool
    let backdropPath: String?
    let genreIDS: [Int]
    let id: Int
    let originalName, overview: String
    let popularity: Double
    let posterPath: String?
    let firstAirDate, name: String
    let voteAverage: Double
    let voteCount: Int
    let character: String?
    let creditID: String
    let episodeCount: Int
    let department, job: String?

    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case genreIDS = "genre_ids"
        case id
        case originalName = "original_name"
        case overview, popularity
        case posterPath = "poster_path"
        case firstAirDate = "first_air_date"
        case name
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case character
        case creditID = "credit_id"
        case episodeCount = "episode_count"
        case department, job
    }
}

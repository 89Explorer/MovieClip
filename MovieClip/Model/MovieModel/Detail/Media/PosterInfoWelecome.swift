//
//  PosterInfoWelecome.swift
//  MovieClip
//
//  Created by 권정근 on 2/11/25.
//

import Foundation


// MARK: - PosterInfoWelcome
struct PosterInfoWelcome: Codable {
    let backdrops: [PosterInfoBackdrop]
    let id: Int
    let logos, posters: [PosterInfoBackdrop]
}

// MARK: - PosterInfoBackdrop
struct PosterInfoBackdrop: Codable {
    let aspectRatio: Double
    let height: Int
    let iso639_1: String?
    let filePath: String?
    let voteAverage: Double
    let voteCount, width: Int

    enum CodingKeys: String, CodingKey {
        case aspectRatio = "aspect_ratio"
        case height
        case iso639_1 = "iso_639_1"
        case filePath = "file_path"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case width
    }
}

//
//  MovieGenre.swift
//  MovieClip
//
//  Created by 권정근 on 2/5/25.
//

import Foundation

// MARK: - MovieGenreWelcome
struct MovieGenreWelcome: Codable {
    let genres: [MovieGenre]
}

// MARK: - MovieGenre
struct MovieGenre: Codable {
    let id: Int
    let name: String
}

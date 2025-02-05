//
//  MovieGenre.swift
//  MovieClip
//
//  Created by 권정근 on 2/5/25.
//

import Foundation

// MARK: - Welcome
struct MovieGenreWelcome: Codable {
    let genres: [MovieGenre]
}

// MARK: - Genre
struct MovieGenre: Codable {
    let id: Int
    let name: String
}

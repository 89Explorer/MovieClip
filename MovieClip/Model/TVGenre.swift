//
//  TVGenre.swift
//  MovieClip
//
//  Created by 권정근 on 2/6/25.
//

import Foundation


// MARK: - TVGenreWelcome
struct TVGenreWelcome: Codable {
    let genres: [TVGenre]
}

// MARK: - TVGenre
struct TVGenre: Codable {
    let id: Int
    let name: String
}

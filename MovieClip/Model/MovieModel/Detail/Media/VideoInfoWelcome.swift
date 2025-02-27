//
//  VideoInfoResult.swift
//  MovieClip
//
//  Created by 권정근 on 2/9/25.
//

import Foundation


// MARK: - VideoInfoWelcome
struct VideoInfoWelcome: Codable {
    let id: Int
    let results: [VideoInfoResult]
}

// MARK: - VideoInfoResult
struct VideoInfoResult: Codable {
    let name, key: String?
    let site: Site
    let size: Int
    let type: String
    let official: Bool
    let publishedAt, id: String

    enum CodingKeys: String, CodingKey {
        case name, key, site, size, type, official
        case publishedAt = "published_at"
        case id
    }
}

enum Site: String, Codable {
    case youTube = "YouTube"
}

//
//  TrendingPeople.swift
//  MovieClip
//
//  Created by 권정근 on 2/6/25.
//

import Foundation

// MARK: - PeopleWelcome
struct PeopleWelcome: Codable {
    let page: Int
    let results: [PeopleResult]
    let totalPages, totalResults: Int

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

// MARK: - PeopleResult
struct PeopleResult: Codable {
    let id: Int
    let name, originalName: String
    let mediaType: PeopleMediaType
    let adult: Bool
    let popularity: Double
    let gender: Int
    let knownForDepartment: KnownForDepartment?
    let profilePath: String?

    enum CodingKeys: String, CodingKey {
        case id, name
        case originalName = "original_name"
        case mediaType = "media_type"
        case adult, popularity, gender
        case knownForDepartment = "known_for_department"
        case profilePath = "profile_path"
    }
}

enum KnownForDepartment: String, Codable {
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
        self = KnownForDepartment(rawValue: value ?? "") ?? .unknown
    }
}

enum PeopleMediaType: String, Codable {
    case person = "person"
}

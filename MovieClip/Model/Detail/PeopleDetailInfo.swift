//
//  PeopleDetailInfo.swift
//  MovieClip
//
//  Created by 권정근 on 2/7/25.
//

import Foundation


// MARK: - PeopleDetailInfoWelcome
struct PeopleDetailInfoWelcome: Codable {
    let adult: Bool
    let alsoKnownAs: [String]
    let biography: String
    let birthday: String?
    let deathday: String? // ✅ JSONNull 대신 String? 적용
    let gender: Int
    let homepage: String? // ✅ JSONNull 대신 String? 적용
    let id: Int
    let imdbID: String?
    let knownForDepartment, name: String
    let placeOfBirth: String?
    let popularity: Double
    let profilePath: String?

    enum CodingKeys: String, CodingKey {
        case adult
        case alsoKnownAs = "also_known_as"
        case biography, birthday, deathday, gender, homepage, id
        case imdbID = "imdb_id"
        case knownForDepartment = "known_for_department"
        case name
        case placeOfBirth = "place_of_birth"
        case popularity
        case profilePath = "profile_path"
    }
}


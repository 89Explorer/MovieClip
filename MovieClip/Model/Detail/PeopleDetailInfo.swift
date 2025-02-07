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
    let biography, birthday: String
    let deathday: JSONNull?
    let gender: Int
    let homepage: JSONNull?
    let id: Int
    let imdbID, knownForDepartment, name, placeOfBirth: String
    let popularity: Double
    let profilePath: String

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

// MARK: - Encode/decode helpers

class PeopleDetailInfoJSONNull: Codable, Hashable {

    public static func == (lhs: PeopleDetailInfoJSONNull, rhs: PeopleDetailInfoJSONNull) -> Bool {
            return true
    }

    public var hashValue: Int {
            return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            if !container.decodeNil() {
                    throw DecodingError.typeMismatch(PeopleDetailInfoJSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
            }
    }

    public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            try container.encodeNil()
    }
}

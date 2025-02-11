//
//  TopBilledCastInfo.swift
//  MovieClip
//
//  Created by 권정근 on 2/10/25.
//

import Foundation


// MARK: - TopBilledCastInfoWelcome
struct TopBilledCastInfoWelcome: Codable {
    let id: Int
    let cast, crew: [TopBilledCastInfo]
}

// MARK: - TopBilledCastInfo
struct TopBilledCastInfo: Codable {
    let adult: Bool
    let gender, id: Int
    let name, originalName: String
    let popularity: Double
    let profilePath: String?
    let castID: Int?
    let character: String?
    let creditID: String
    let order: Int?
    let department, job: String?

    enum CodingKeys: String, CodingKey {
        case adult, gender, id
        case name
        case originalName = "original_name"
        case popularity
        case profilePath = "profile_path"
        case castID = "cast_id"
        case character
        case creditID = "credit_id"
        case order, department, job
    }
}

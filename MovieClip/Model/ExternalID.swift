//
//  ExternalID.swift
//  MovieClip
//
//  Created by 권정근 on 2/13/25.
//

import Foundation

// MARK: - Welcome
struct ExternalID: Codable {
    let id: Int
    let facebookID, instagramID, twitterID: String?
    let youtubeID: String?

    enum CodingKeys: String, CodingKey {
        case id
        case facebookID = "facebook_id"
        case instagramID = "instagram_id"
        case twitterID = "twitter_id"
        case youtubeID = "youtube_id"
    }
}

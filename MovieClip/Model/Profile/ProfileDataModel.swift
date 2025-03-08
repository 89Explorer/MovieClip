//
//  ProfileDataModel.swift
//  MovieClip
//
//  Created by 권정근 on 3/1/25.
//

import Foundation


// MARK: - Enum으로 섹션 정의
enum ProfileSection: String, CaseIterable {
    case profile = "프로필"
    //case ratedMovies = "평점 준 작품"
    case myReviews = "내가 쓴 리뷰"
}

// MARK: - 데이터 모델(item) 만들기
enum ProfileItem: Hashable {
    case profile(MovieClipUser)      // ✅ 기존 모델 사용
    //case ratedMovies([WorkOfMedia])
    case review (ReviewItem)
}

// MARK: - 각 데이터 타입 정의
struct WorkOfMedia: Codable, Hashable {
    let id: Int
    let backdropPath: String?
    let posterPath: String?
    let releaseDate: String?
    let voteAverage: Double?
    let overview: String
    let name: String?
    let title: String?
    let firstAirDate: String?
    
    
    enum CodingKeys: String, CodingKey{
        case id
        case backdropPath = "backdrop_path"
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
        case overview
        case name
        case title
        case firstAirDate = "first_air_date"
    }
    
}



struct Review: Hashable, Codable {
    let id: Int
    var title: String? = ""
    var content: String? = ""
    var date: Date? = Date()
    var imagePath: [String]? = []
}

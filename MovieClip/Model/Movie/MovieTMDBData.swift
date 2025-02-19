//
//  MovieListWelcome.swift
//  MovieClip
//
//  Created by 권정근 on 2/18/25.
//

import Foundation


// MARK: - Welcome
struct CombineData: Codable, Hashable{
    var combineTMDB: [TMDBData]
}

struct TMDBData: Codable, Hashable {
    var results: [MainResults]
    var type: SectionType?
    var total_pages: Int
    var total_results: Int
    var dates: MovieListDates?
}

// MARK: - MovieListDates
struct MovieListDates: Codable, Hashable {
    let maximum, minimum: String
}



// MARK: - Result
struct MainResults: Codable, Hashable {
    var id: Int
    var original_title: String?
    var overview: String
    var popularity: Double?
    var poster_path: String?
    var release_date: String
    var title: String?
    var name: String?
    var vote_average: Double?
    var vote_count: Int
    var genre_ids: [Int]
    var genreNames: [String]?
}


enum SectionType: String, Codable {
    case noewPlayingMovie = "Now Playing Movie"
    case popularMovie = "Popular Movie"
    case topRatedMovie = "Top Rated Movie"
    case upcomingMovie = "Upcoming Movie"
    case trendMovies = "Trending Movies"
}



/*
 // MARK: - CombineData
 // ✅ 전체 데이터를 저장하는 구조체
 struct CombineData: Codable, Hashable {
 var combineMovieData: [MovieListWelcome]   // ✅ MovieListWelcome 데이터를 여러 개 섹션으로 저장
 }
 
 
 // MARK: - MovieListWelcome
 // ✅ 개별 섹션 정보 저장
 struct MovieListWelcome: Codable, Hashable {
 var dates: MovieListDates?
 var page: Int
 var results: [MovieListResult]   // ✅ 해당 섹션의 영화 목록
 var type: MovieSectionType?           // ✅ 섹션 타입 (예: 최신, 인기, 순위 영화 등) 저장
 var totalPages, totalResults: Int
 
 enum CodingKeys: String, CodingKey, Hashable {
 case dates, page, results
 case totalPages = "total_pages"
 case totalResults = "total_results"
 }
 }
 
 
 // MARK: - MovieListDates
 struct MovieListDates: Codable, Hashable {
 let maximum, minimum: String
 }
 
 
 // MARK: - MovieListResult
 // ✅ 개별 영화 데이터
 struct MovieListResult: Codable, Hashable {
 let adult: Bool
 let backdropPath: String
 let genreIDS: [Int]
 let id: Int
 let originalTitle, overview: String
 let popularity: Double
 let posterPath, releaseDate, title: String
 let video: Bool
 let voteAverage: Double
 let voteCount: Int
 var genreNames: [String]?     // 장르 이름 저장
 
 enum CodingKeys: String, CodingKey, Hashable {
 case adult
 case backdropPath = "backdrop_path"
 case genreIDS = "genre_ids"
 case id
 case originalTitle = "original_title"
 case overview, popularity
 case posterPath = "poster_path"
 case releaseDate = "release_date"
 case title, video
 case voteAverage = "vote_average"
 case voteCount = "vote_count"
 }
 }
 
 
 // MARK: - SectionType
 // ✅ 컬렉션 뷰의 섹션 구분
 enum MovieSectionType: String, Codable {
 case noewPlayingMovie = "Now Playing Movie"
 case popularMovie = "Popular Movie"
 case topRatedMovie = "Top Rated Movie"
 case upcomingMovie = "Upcoming Movie"
 }
 */

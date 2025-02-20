//
//  NetworkManager.swift
//  MovieClip
//
//  Created by 권정근 on 2/5/25.
//

import Foundation


// MARK: - Constants
struct Constants {
    
    /// 주소
    static let baseURL = "https://api.themoviedb.org/3"
    
    static let API_KEY = "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI2NzgwMjVmOWI4NTM3Mjk5MjI3NDhkMTZmZWI0NDJmOSIsIm5iZiI6MTcwOTUxNjg3OS44NjcsInN1YiI6IjY1ZTUyODRmMjBlNmE1MDE4NjUzYzIwYSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.IN8NuxkHHsjWjR7kSkmz83kONEwQI699ZKFUiWVajow"
    
}


// MARK: - ERROR
enum APIError: Error {
    case failedToGetData
    case emptyResults
}


// MARK: - APICaller
class NetworkManager {
    
    static let shared = NetworkManager()
    
    /// 🚗 영화  목록을 가져오는 함수
    func getTrendingMovies() async throws -> [MovieResult] {
        let url = URL(string: "\(Constants.baseURL)/trending/movie/week")!
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "language", value: "ko-KR"),
            URLQueryItem(name: "adult", value: "true")
            
        ]
        components.queryItems = components.queryItems.map { $0 + queryItems } ?? queryItems
        
        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = [
            "accept": "application/json",
            "Authorization": "Bearer \(Constants.API_KEY)"
        ]
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else { throw APIError.failedToGetData }
        
        let results = try JSONDecoder().decode(MovieWelcome.self, from: data)
        
        return results.results
    }
    
    /// 🚗 영화 장르 정보를 가져오는 함수
    func getMovieGenre() async throws -> [MovieGenre] {
        let url = URL(string: "\(Constants.baseURL)/genre/movie/list")!
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "language", value: "ko"),
        ]
        components.queryItems = components.queryItems.map { $0 + queryItems } ?? queryItems
        
        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = [
            "accept": "application/json",
            "Authorization": "Bearer \(Constants.API_KEY)"
        ]
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else { throw APIError.failedToGetData }
        
        let results = try JSONDecoder().decode(MovieGenreWelcome.self, from: data)
        
        return results.genres
    }
    
    /// 🚗 티비  목록을 가져오는 함수
    func getTrendingTVs() async throws -> [TVResult] {
        let url = URL(string: "\(Constants.baseURL)/trending/tv/week")!
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "language", value: "ko-KR"),
        ]
        components.queryItems = components.queryItems.map { $0 + queryItems } ?? queryItems
        
        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = [
            "accept": "application/json",
            "Authorization": "Bearer \(Constants.API_KEY)"
        ]
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else { throw APIError.failedToGetData }
        
        let resultes = try JSONDecoder().decode(TVWelcome.self, from: data)
        
        return resultes.results
    }
    
    /// 🚗 TV 장르 정보를 가져오는 함수
    func getTVGenre() async throws -> [TVGenre] {
        let url = URL(string: "\(Constants.baseURL)/genre/tv/list")!
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "language", value: "ko"),
        ]
        components.queryItems = components.queryItems.map { $0 + queryItems } ?? queryItems
        
        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = [
            "accept": "application/json",
            "Authorization": "Bearer \(Constants.API_KEY)"
        ]
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else { throw APIError.failedToGetData }
        
        let results = try JSONDecoder().decode(TVGenreWelcome.self, from: data)
        
        return results.genres
    }
    
    /// 🚗 배우 목록을 가져오는 함수
    func getTrendingPeoples() async throws -> [PeopleResult] {
        let url = URL(string: "\(Constants.baseURL)/trending/person/week")!
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "language", value: "en-US"),
        ]
        components.queryItems = components.queryItems.map { $0 + queryItems } ?? queryItems
        
        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = [
            "accept": "application/json",
            "Authorization": "Bearer \(Constants.API_KEY)"
        ]
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else { throw APIError.failedToGetData }
        
        let resultes = try JSONDecoder().decode(PeopleWelcome.self, from: data)
        
        return resultes.results
    }
    
    /// 🚗 trending moviel 의 전체 페이지 검색 결과 중에 총 페이지 수 반환 메서드
    func getTotalPages() async throws -> Int {
        let url = URL(string: "\(Constants.baseURL)/trending/movie/week")!
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "language", value: "ko-KR"),
            URLQueryItem(name: "page", value: "1") // ✅ 1페이지 요청 (총 페이지 수 확인 목적)
        ]
        components.queryItems = components.queryItems.map { $0 + queryItems } ?? queryItems
        
        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = [
            "accept": "application/json",
            "Authorization": "Bearer \(Constants.API_KEY)"
        ]
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else { throw APIError.failedToGetData }
        
        let result = try JSONDecoder().decode(MovieWelcome.self, from: data)
        return result.totalPages // ✅ 총 페이지 수 반환
    }
    
    
    /// 트렌드 영화 전체에서 1개 영화 가져오기
    func getRandomTrendingMovie() async throws -> MovieResult {
        let totalPages = try await getTotalPages() // ✅ 1. 총 페이지 수 가져오기
        let randomPage = Int.random(in: 1...totalPages) // ✅ 2. 랜덤 페이지 선택
        
        let url = URL(string: "\(Constants.baseURL)/trending/movie/week")!
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "language", value: "ko-KR"),
            URLQueryItem(name: "page", value: "\(randomPage)") // ✅ 3. 랜덤 페이지 요청
        ]
        components.queryItems = components.queryItems.map { $0 + queryItems } ?? queryItems
        
        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = [
            "accept": "application/json",
            "Authorization": "Bearer \(Constants.API_KEY)"
        ]
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else { throw APIError.failedToGetData }
        
        let results = try JSONDecoder().decode(MovieWelcome.self, from: data)
        
        // ✅ 랜덤으로 1개 선택
        if let randomMovie = results.results.randomElement() {
            return randomMovie
        } else {
            throw APIError.emptyResults // ✅ 결과가 없을 경우 에러 처리
        }
    }
    
    /// 🚗 상세 페이지, 영화 Id를 통해 상세 정보 가져오기
    func getMovieDetailInfo(movieID: Int) async throws -> MovieDetailInfoWelcome {
        let url = URL(string: "\(Constants.baseURL)/movie/\(movieID)")!
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "language", value: "ko-KR")
        ]
        components.queryItems = components.queryItems.map { $0 + queryItems } ?? queryItems
        
        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = [
            "accept": "application/json",
            "Authorization": "Bearer \(Constants.API_KEY)"
        ]
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw APIError.failedToGetData
        }
        
        let movieDetail = try JSONDecoder().decode(MovieDetailInfoWelcome.self, from: data)
        return movieDetail
    }
    
    /// 🚗 상세 페이지, TV Id를 통해 상세 정보 가져오기
    func getTVDetailInfo(tvID: Int) async throws -> TVDetailInfoWelcome {
        let url = URL(string: "\(Constants.baseURL)/tv/\(tvID)")!
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "language", value: "ko-KR")
        ]
        components.queryItems = components.queryItems.map { $0 + queryItems } ?? queryItems
        
        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = [
            "accept": "application/json",
            "Authorization": "Bearer \(Constants.API_KEY)"
        ]
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw APIError.failedToGetData
        }
        
        let tvDetail = try JSONDecoder().decode(TVDetailInfoWelcome.self, from: data)
        return tvDetail
    }
    
    
    /// 🚗 상세 페이지, People Id를 통해 상세 정보 가져오기
    func getPeopleDetailInfo(peopleID: Int) async throws -> PeopleDetailInfoWelcome {
        let url = URL(string: "\(Constants.baseURL)/person/\(peopleID)")!
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "language", value: "en-US")
        ]
        components.queryItems = components.queryItems.map { $0 + queryItems } ?? queryItems
        
        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = [
            "accept": "application/json",
            "Authorization": "Bearer \(Constants.API_KEY)"
        ]
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw APIError.failedToGetData
        }
        
        let peopleDetail = try JSONDecoder().decode(PeopleDetailInfoWelcome.self, from: data )
        return peopleDetail 
    }
    
    
    /// 🎥 영화 캐스팅 정보 가져오기 
    func getMovieCastInfo(contentID: Int) async throws -> TopBilledCastInfoWelcome {
        let url = URL(string: "\(Constants.baseURL)/movie/\(contentID)/credits")!
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "language", value: "en-US"),
        ]
        components.queryItems = components.queryItems.map { $0 + queryItems } ?? queryItems
        
        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = [
            "accept": "application/json",
            "Authorization": "Bearer \(Constants.API_KEY)"
        ]
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw APIError.failedToGetData
        }
        
        let movieCastInfo = try JSONDecoder().decode(TopBilledCastInfoWelcome.self, from: data)
        
        return movieCastInfo
        
    }
    
    
    /// 🎥 영화 캐스팅 정보 가져오기
    func getTVCastInfo(contentID: Int) async throws -> TopBilledCastInfoWelcome {
        let url = URL(string: "\(Constants.baseURL)/tv/\(contentID)/credits")!
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "language", value: "en-US"),
        ]
        components.queryItems = components.queryItems.map { $0 + queryItems } ?? queryItems
        
        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = [
            "accept": "application/json",
            "Authorization": "Bearer \(Constants.API_KEY)"
        ]
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw APIError.failedToGetData
        }
        
        let movieCastInfo = try JSONDecoder().decode(TopBilledCastInfoWelcome.self, from: data)
        
        return movieCastInfo
        
    }
    
    
    /// 🚗 contentId를 통해 영상정보 가져오기
    func getMovieVideoInfo(contentID: Int) async throws -> VideoInfoWelcome {
        let url = URL(string: "\(Constants.baseURL)/movie/\(contentID)/videos")!
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "language", value: "en-US"),
        ]
        components.queryItems = components.queryItems.map { $0 + queryItems } ?? queryItems
        
        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = [
            "accept": "application/json",
            "Authorization": "Bearer \(Constants.API_KEY)"
        ]
        
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw APIError.failedToGetData
        }
        
        let movieVideo = try JSONDecoder().decode(VideoInfoWelcome.self, from: data)
        return movieVideo
        
    }
    
    /// 🚗 contentId를 통해 tv 영상 정보 가져오기
    func getTvVideoInfo(contentID: Int) async throws -> VideoInfoWelcome {
        let url = URL(string: "\(Constants.baseURL)/tv/\(contentID)/videos")!
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "language", value: "en-US"),
        ]
        components.queryItems = components.queryItems.map { $0 + queryItems } ?? queryItems
        
        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = [
            "accept": "application/json",
            "Authorization": "Bearer \(Constants.API_KEY)"
        ]
        
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw APIError.failedToGetData
        }
        
        let tvVideo = try JSONDecoder().decode(VideoInfoWelcome.self, from: data)
        return tvVideo
        
    }
    
    
    /// 🚗 contentId를 통해 이미지 정보 가져오기
    func getMoviePosterInfo(contentID: Int) async throws -> PosterInfoWelcome {
        let url = URL(string: "\(Constants.baseURL)/movie/\(contentID)/images")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = [
            "accept": "application/json",
            "Authorization": "Bearer \(Constants.API_KEY)"
        ]
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw APIError.failedToGetData
        }
        
        let moviePoster = try JSONDecoder().decode(PosterInfoWelcome.self, from: data)
        
        return moviePoster
    }
    
    /// 🚗 contentId를 통해 tv 이미지 정보 가져오기
    func getTvPosterInfo(contentID: Int) async throws -> PosterInfoWelcome {
        let url = URL(string: "\(Constants.baseURL)/tv/\(contentID)/images")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = [
            "accept": "application/json",
            "Authorization": "Bearer \(Constants.API_KEY)"
        ]
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw APIError.failedToGetData
        }
        
        let tvPoster = try JSONDecoder().decode(PosterInfoWelcome.self, from: data)
        
        return tvPoster
    }
    
    /// 🚗 contentId를 통해 유사한 영화 정보 가져오기
    func getMovieSimilarInfo(contentID: Int) async throws -> [MovieResult] {
        let url = URL(string: "\(Constants.baseURL)/movie/\(contentID)/similar")!
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "language", value: "en-US"),
            URLQueryItem(name: "page", value: "1"),
        ]
        components.queryItems = components.queryItems.map { $0 + queryItems } ?? queryItems
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = [
            "accept": "application/json",
            "Authorization": "Bearer \(Constants.API_KEY)"
        ]
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw APIError.failedToGetData
        }
        
        let movieSimilarInfo = try JSONDecoder().decode(MovieWelcome.self, from: data)
        
        return movieSimilarInfo.results
    }
    
    
    /// 🚗 contentId를 통해 유사한 tv 정보 가져오기
    func getTVSimilarInfo(contentID: Int) async throws -> [TVResult] {
        let url = URL(string: "\(Constants.baseURL)/tv/\(contentID)/similar")!
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "language", value: "en-US"),
            URLQueryItem(name: "page", value: "1"),
        ]
        components.queryItems = components.queryItems.map { $0 + queryItems } ?? queryItems
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = [
            "accept": "application/json",
            "Authorization": "Bearer \(Constants.API_KEY)"
        ]
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw APIError.failedToGetData
        }
        
        let tvSimilarInfo = try JSONDecoder().decode(TVWelcome.self, from: data)
        
        return tvSimilarInfo.results
    }
    
    
    /// 🚗 peopleID를 통해 사람의 외부 소셜네트워크 확인 
    func getPeopleExternalIDs(peopleID: Int) async throws -> ExternalID {
        let url = URL(string: "\(Constants.baseURL)/person/\(peopleID)/external_ids")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = [
            "accept": "application/json",
            "Authorization": "Bearer \(Constants.API_KEY)"
        ]
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw APIError.failedToGetData
        }
        
        let peopleExternalIDs = try JSONDecoder().decode(ExternalID.self, from: data)
        
        return peopleExternalIDs
        
    }
    
    /// 🚗 peopleID를 통해 사람의 영화 출연작 확인
    func getMovieCredits(peopleID: Int) async throws -> MovieCreditWelcome{
        let url = URL(string: "\(Constants.baseURL)/person/\(peopleID)/movie_credits")!
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        let queryItems: [URLQueryItem] = [
          URLQueryItem(name: "language", value: "en-US"),
        ]
        components.queryItems = components.queryItems.map { $0 + queryItems } ?? queryItems

        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = [
            "accept": "application/json",
            "Authorization": "Bearer \(Constants.API_KEY)"
        ]
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw APIError.failedToGetData
        }
        
        let movieCredits = try JSONDecoder().decode(MovieCreditWelcome.self, from: data)
        return movieCredits
    }

    /// 🚗 peopleID를 통해 사람의 tv 출연작 확인
    func getTVCredits(peopleID: Int) async throws -> TVCreditWelcome {
        let url = URL(string: "\(Constants.baseURL)/person/\(peopleID)/tv_credits")!
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        let queryItems: [URLQueryItem] = [
          URLQueryItem(name: "language", value: "en-US"),
        ]
        components.queryItems = components.queryItems.map { $0 + queryItems } ?? queryItems

        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = [
            "accept": "application/json",
            "Authorization": "Bearer \(Constants.API_KEY)"
        ]

        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw APIError.failedToGetData
        }
        
        let tvCredits = try JSONDecoder().decode(TVCreditWelcome.self, from: data)
        return tvCredits
    }
    
    // MARK: - Movie Sections
    
    /// 🚗 특정기간 동안 상영중인 영화
    func getMovieNowPlaying(pageNo: Int = 1) async throws -> TMDBData {
        let url = URL(string: "\(Constants.baseURL)/movie/now_playing")!
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        let queryItems: [URLQueryItem] = [
          URLQueryItem(name: "language", value: "en-US"),
          URLQueryItem(name: "page", value: "\(pageNo)"),
        ]
        components.queryItems = components.queryItems.map { $0 + queryItems } ?? queryItems

        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = [
            "accept": "application/json",
            "Authorization": "Bearer \(Constants.API_KEY)"
        ]
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw APIError.failedToGetData
        }
        
        var movieNowPlaying = try JSONDecoder().decode(TMDBData.self, from: data)
        movieNowPlaying.type = .noewPlayingMovie
        
        return movieNowPlaying
    }
    
    /// 🚗 인기있는 영화 목록 가져오기
    func getMoviePopular(pageNo: Int = 1) async throws -> TMDBData {
        let url = URL(string: "\(Constants.baseURL)/movie/popular")!
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        let queryItems: [URLQueryItem] = [
          URLQueryItem(name: "language", value: "en-US"),
          URLQueryItem(name: "page", value: "1"),
        ]
        components.queryItems = components.queryItems.map { $0 + queryItems } ?? queryItems

        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = [
            "accept": "application/json",
            "Authorization": "Bearer \(Constants.API_KEY)"
        ]
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw APIError.failedToGetData
        }
        
        var moviePopular = try JSONDecoder().decode(TMDBData.self, from: data)
        moviePopular.type = .popularMovie
        
        return moviePopular
    }
    
    
    /// 🚗 영화 순위 가져오기
    func getMovieTopRated(pageNo: Int = 1) async throws -> TMDBData {
        let url = URL(string: "\(Constants.baseURL)/movie/top_rated")!
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        let queryItems: [URLQueryItem] = [
          URLQueryItem(name: "language", value: "en-US"),
          URLQueryItem(name: "page", value: "1"),
        ]
        components.queryItems = components.queryItems.map { $0 + queryItems } ?? queryItems

        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = [
            "accept": "application/json",
            "Authorization": "Bearer \(Constants.API_KEY)"
        ]

        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw APIError.failedToGetData
        }
        
        var movieTopRated = try JSONDecoder().decode(TMDBData.self, from: data)
        movieTopRated.type = .topRatedMovie
        
        return movieTopRated
    }
    
    /// 🚗 영화 개봉예정작 가져오기
    func getMovieUpcoming(pageNo: Int = 1) async throws -> TMDBData {
        let url = URL(string: "\(Constants.baseURL)/movie/upcoming")!
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        let queryItems: [URLQueryItem] = [
          URLQueryItem(name: "language", value: "ko-KR"),
          URLQueryItem(name: "page", value: "1"),
        ]
        components.queryItems = components.queryItems.map { $0 + queryItems } ?? queryItems

        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = [
            "accept": "application/json",
            "Authorization": "Bearer \(Constants.API_KEY)"
        ]

        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw APIError.failedToGetData
        }
        
        var movieUpcoming = try JSONDecoder().decode(TMDBData.self, from: data)
        movieUpcoming.type = .upcomingMovie
        
        return movieUpcoming
    }
    
    /// 🚗 영화의 모든 카테고리 정보를 받아오는 함수
    func fetchAllMovies() async throws -> CombineData {
        
        // 비동기 API 호출 동시에 실행
        async let movieNowPlaying = getMovieNowPlaying()
        async let moviePopular = getMoviePopular()
        async let movieTopRated = getMovieTopRated()
        async let movieUpcoming = getMovieUpcoming()
        
        
        // 모든 비동기 작업의 결과 대기
        let nowPlayingResult = try await movieNowPlaying
        let popularResult = try await moviePopular
        let topRatedResult = try await movieTopRated
        let upcomingResult = try await movieUpcoming
        
        
        // 결과를 하나의 영화 객체로 결합
        var combinedData: CombineData = CombineData(combineTMDB: [])
        
        
        // 각 결과를 combinedData에 추가
        combinedData.combineTMDB.append(nowPlayingResult)
        combinedData.combineTMDB.append(popularResult)
        combinedData.combineTMDB.append(topRatedResult)
        combinedData.combineTMDB.append(upcomingResult)
        
        return combinedData
    }

    
    // MARK: - Tv Section
    /// 🚗 오늘 방송인 TV
    func getTvAiringToday(pageNo: Int = 1) async throws -> TvTMDBData {
        let url = URL(string: "\(Constants.baseURL)/tv/airing_today")!
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        let queryItems: [URLQueryItem] = [
          URLQueryItem(name: "language", value: "en-US"),
          URLQueryItem(name: "page", value: "\(pageNo)"),
        ]
        components.queryItems = components.queryItems.map { $0 + queryItems } ?? queryItems

        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = [
            "accept": "application/json",
            "Authorization": "Bearer \(Constants.API_KEY)"
        ]
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw APIError.failedToGetData
        }
        
        var tvAiringToday = try JSONDecoder().decode(TvTMDBData.self, from: data)
        tvAiringToday.type = .airingToday
        
        return tvAiringToday
    }
    
    /// 🚗 앞으로 7일동안 방송될 TV
    func getTvOnTheAir(pageNo: Int = 1) async throws -> TvTMDBData {
        let url = URL(string: "\(Constants.baseURL)/tv/on_the_air")!
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        let queryItems: [URLQueryItem] = [
          URLQueryItem(name: "language", value: "en-US"),
          URLQueryItem(name: "page", value: "\(pageNo)"),
        ]
        components.queryItems = components.queryItems.map { $0 + queryItems } ?? queryItems

        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = [
            "accept": "application/json",
            "Authorization": "Bearer \(Constants.API_KEY)"
        ]
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw APIError.failedToGetData
        }
        
        var tvOnTheAir = try JSONDecoder().decode(TvTMDBData.self, from: data)
        tvOnTheAir.type = .onTheAir
        
        return tvOnTheAir
    }
    
    
    /// 🚗 인기순으로 정렬된 TV 프로그램 목록
    func getTvPopular(pageNo: Int = 1) async throws -> TvTMDBData {
        let url = URL(string: "\(Constants.baseURL)/tv/popular")!
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        let queryItems: [URLQueryItem] = [
          URLQueryItem(name: "language", value: "en-US"),
          URLQueryItem(name: "page", value: "\(pageNo)"),
        ]
        components.queryItems = components.queryItems.map { $0 + queryItems } ?? queryItems

        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = [
            "accept": "application/json",
            "Authorization": "Bearer \(Constants.API_KEY)"
        ]
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw APIError.failedToGetData
        }
        
        var tvPopular = try JSONDecoder().decode(TvTMDBData.self, from: data)
        tvPopular.type = .popular
        
        return tvPopular
    }
    
    
    /// 🚗 인기순으로 정렬된 TV 프로그램 목록
    func getTvTopRated(pageNo: Int = 1) async throws -> TvTMDBData {
        let url = URL(string: "\(Constants.baseURL)/tv/top_rated")!
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        let queryItems: [URLQueryItem] = [
          URLQueryItem(name: "language", value: "en-US"),
          URLQueryItem(name: "page", value: "\(pageNo)"),
        ]
        components.queryItems = components.queryItems.map { $0 + queryItems } ?? queryItems

        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = [
            "accept": "application/json",
            "Authorization": "Bearer \(Constants.API_KEY)"
        ]
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw APIError.failedToGetData
        }
        
        var tvTopRated = try JSONDecoder().decode(TvTMDBData.self, from: data)
        tvTopRated.type = .topRated
        
        return tvTopRated
    }
    
    /// 🚗 TV 전체 데이터 가져오기
    func fetchAllTvs() async throws -> TvCombineData {
        
        // 비동기 API 호출 동시에 실행
        async let tvAiringToday = getTvAiringToday()
        async let tvOnTheAir = getTvOnTheAir()
        async let tvPopular = getTvPopular()
        async let tvTopRated = getTvTopRated()
        
        // 모든 비동기 작업의 결과 대기
        let airingToday = try await tvAiringToday
        let onTheAir = try await tvOnTheAir
        let popular = try await tvPopular
        let topRated = try await tvTopRated
        
        // 결과를 하나의 TV 객체로 결합
        var combinedData: TvCombineData = TvCombineData(combineTMDB: [])
        
        // 각 결과를 combinedData에 추가
        combinedData.combineTMDB.append(airingToday)
        combinedData.combineTMDB.append(onTheAir)
        combinedData.combineTMDB.append(popular)
        combinedData.combineTMDB.append(topRated)
        
        return combinedData
    }
    
}


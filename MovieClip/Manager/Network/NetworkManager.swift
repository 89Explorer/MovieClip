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
    
    
    // 구글 클라우드 번역 API를 통해 번역하는 메서드
    func translateText(_ text: String) async -> String {
        let apiKey = "AIzaSyCFdYxCxHXF07ssuM2ie9rEm6EQ6EDyJ0o"
        let targetLanguage = "ko" // 한국어(Korean)로 번역
        let sourceLanguage = "en" // 영어(English)로부터 번역
        
        // ✅ API 요청 URL 생성
        let urlString = "https://translation.googleapis.com/language/translate/v2?key=\(apiKey)"
        guard let url = URL(string: urlString) else {
            return text         // ✅ 번역 실패 시 원본 반환
        }
        
        // ✅ 요청 데이터 설정 (JSON Body)
        let parameters: [String: Any] = [
            "q": text, // 번역할 텍스트
            "source": sourceLanguage, // 원본 언어
            "target": targetLanguage, // 번역할 언어
            "format": "text"
        ]

        guard let jsonData = try? JSONSerialization.data(withJSONObject: parameters) else {
            return text
        }
        
        // ✅ URLRequest 설정
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
    
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]

            if let data = json?["data"] as? [String: Any],
               let translations = data["translations"] as? [[String: Any]],
               let translatedText = translations.first?["translatedText"] as? String {
                return translatedText // ✅ 번역 결과 반환
            } else {
                return text // ✅ 번역 실패 시 원본 반환
            }
        } catch {
            return text
        }
    }
}


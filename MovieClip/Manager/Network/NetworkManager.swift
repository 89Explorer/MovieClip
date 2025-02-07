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
    
    /// 🚗 trending All 의 전체 페이지 검색 결과 중에 총 페이지 수 반환 메서드
    func getTotalPages() async throws -> Int {
        let url = URL(string: "\(Constants.baseURL)/trending/all/week")!
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
        
        let result = try JSONDecoder().decode(AllWelcome.self, from: data)
        return result.totalPages // ✅ 총 페이지 수 반환
    }
    
    
    func getRandomTrendingAll() async throws -> AllResult {
        let totalPages = try await getTotalPages() // ✅ 1. 총 페이지 수 가져오기
            let randomPage = Int.random(in: 1...totalPages) // ✅ 2. 랜덤 페이지 선택

            let url = URL(string: "\(Constants.baseURL)/trending/all/week")!
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
            
            let results = try JSONDecoder().decode(AllWelcome.self, from: data)

            // ✅ 랜덤으로 1개 선택
            if let randomMovie = results.results.randomElement() {
                return randomMovie
            } else {
                throw APIError.emptyResults // ✅ 결과가 없을 경우 에러 처리
            }
    }
    
}




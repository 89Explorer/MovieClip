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
    
    
}




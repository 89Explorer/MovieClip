//
//  SearchService.swift
//  MovieClip
//
//  Created by 권정근 on 2/21/25.
//

import Foundation

class SearchService {
    
    // MARK: - Variable
    private let networkhManager = NetworkManager.shared
    
    
    // MARK: - Function
    func searchAll(with keyword: String, page: Int = 1) async throws -> (movies: SearchResultMedia, tvShows: SearchResultMedia, people: SearchResultPerson) {
        
        async let movies = try networkhManager.searchMovie(with: keyword)
        async let tvShows =  try networkhManager.searchTV(with: keyword)
        async let people = try networkhManager.searchPerson(with: keyword)
        
        return try await (movies: movies, tvShows: tvShows, people: people)
    }
}

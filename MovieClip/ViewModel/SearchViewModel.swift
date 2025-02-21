//
//  SearchViewModel.swift
//  MovieClip
//
//  Created by 권정근 on 2/21/25.
//

import Foundation
import Combine

@MainActor
class SearchViewModel: ObservableObject {
    
    @Published var movies: [MediaResult] = []
    @Published var tvShows: [MediaResult] = []
    @Published var people: [PersonResult] = []
    
    @Published var canLoadMoreMovies: Bool = true
    @Published var canLoadMoreTVShows: Bool = true
    @Published var canLoadMorePeople: Bool = true
    
    private let searchService = SearchService()
    private var cancellables = Set<AnyCancellable>()
    
    private var currentQuery: String = ""
    private var moviePage: Int = 1
    private var tvPage: Int = 1
    private var peoplePage: Int = 1
    
    
    // MARK: - Function
    func search(query: String) {
        
        currentQuery = query
        moviePage = 1
        tvPage = 1
        peoplePage = 1
        
        canLoadMoreMovies = true
        canLoadMoreTVShows = true
        canLoadMorePeople = true
        
        
        Task {
            do {
                // 검색 실행
                let results = try await searchService.searchAll(with: query, page: 1)
                
                DispatchQueue.main.async {
                    self.movies = Array(results.movies.results.prefix(3))
                    self.tvShows = Array(results.tvShows.results.prefix(3))
                    self.people = Array(results.people.results.prefix(3))
                    
                    self.canLoadMoreMovies = results.movies.results.count > 3
                    self.canLoadMoreTVShows = results.tvShows.results.count > 3
                    self.canLoadMorePeople = results.people.results.count > 3                }
            }
            catch {
                print("❌ 검색결과요청 실패: \(error.localizedDescription)")
            }
        }
    }
    
    func loadMoreMovies() {
        guard canLoadMoreMovies else { return }
        
        Task {
            do {
                moviePage += 1
                let moreMovies = try await NetworkManager.shared.searchMovie(with: currentQuery, page: moviePage)
                DispatchQueue.main.async {
                    let newMovies = moreMovies.results.prefix(3)
                    self.movies.append(contentsOf: newMovies)
                    
                    // ✅ 추가할 데이터가 더 이상 없으면 더보기 비활성화
                    self.canLoadMoreMovies = newMovies.count == 3
                }
            } catch {
                print("❌ 추가 영화 로드 실패: \(error.localizedDescription)")
            }
        }
    }
    
    func loadMoreTVShows() {
        guard canLoadMoreTVShows else { return }
        
        Task {
            do {
                tvPage += 1
                let moreTVShows = try await NetworkManager.shared.searchTV(with: currentQuery, page: tvPage)
                DispatchQueue.main.async {
                    let newTVShows = moreTVShows.results.prefix(3)
                    self.tvShows.append(contentsOf: newTVShows)
                    
                    self.canLoadMoreTVShows = newTVShows.count == 3
                }
            } catch {
                print("❌ 추가 TV 로드 실패: \(error.localizedDescription)")
            }
        }
    }
    
    func loadMorePeople() {
        guard canLoadMorePeople else { return }
        
        Task {
            do {
                peoplePage += 1
                let morePeople = try await NetworkManager.shared.searchPerson(with: currentQuery, page: peoplePage)
                DispatchQueue.main.async {
                    let newPeople = morePeople.results.prefix(3)
                    self.people.append(contentsOf: newPeople)
                    
                    self.canLoadMorePeople = newPeople.count == 3
                }
            } catch {
                print("❌ 추가 인물 로드 실패: \(error.localizedDescription)")
            }
        }
    }
}

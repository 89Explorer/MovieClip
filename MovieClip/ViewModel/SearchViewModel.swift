//
//  SearchViewModel.swift
//  MovieClip
//
//  Created by 권정근 on 2/21/25.
//

import Foundation
import Combine


class SearchViewModel: ObservableObject {
    
    @Published var movies: [MediaResult] = []
    @Published var tvShows: [MediaResult] = []
    @Published var people: [PersonResult] = []
    
    @Published var canLoadMoreMovies = false
    @Published var canLoadMoreTVShows = false
    @Published var canLoadMorePeople = false
    
    @Published var translatedMovieOverviews: [Int: String] = [:]  // 영화 overview 번역 저장
    @Published var translatedTVOverviews: [Int: String] = [:]      // TV overview 번역 저장
    @Published var translatedPeopleBiographies: [Int: String] = [:] // 사람 biography 번역 저장
    
    @Published var fetchedGenres: [Int: [String]] = [:]    // 장르 저장 변수
    
    private let searchService = SearchService()
    private var cancellables = Set<AnyCancellable>()
    
    private var currentQuery = ""
    private var moviePage = 1
    private var tvPage = 1
    private var peoplePage = 1
    
    private var totalMoviesCount = 0
    private var totalTVShowsCount = 0
    private var totalPeopleCount = 0
    
    // MARK: - 검색 실행
    func search(query: String) {
        currentQuery = query
        resetState()
        
        Task {
            do {
                let results = try await searchService.searchAll(with: query, page: 1)
                DispatchQueue.main.async {
                    self.movies = results.movies.results
                    self.tvShows = results.tvShows.results
                    self.people = results.people.results
                    
                    self.totalMoviesCount = results.movies.totalResults
                    self.totalTVShowsCount = results.tvShows.totalResults
                    self.totalPeopleCount = results.people.totalResults

                    
                    self.translateOverviews(for: .movie(self.movies))
                    self.translateOverviews(for: .tv(self.tvShows))
                    
                    self.fetchGenre(for: .movie(self.movies))
                    self.fetchGenre(for: .tv(self.tvShows))
                    
                    self.updateLoadMoreStatus()
                }
                
            } catch {
                print("❌ 검색 요청 실패: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - 더보기 실행 (불필요한 요청 방지)
    func loadMore(for type: SearchSection) {
        switch type {
        case .movie:
            guard movies.count < totalMoviesCount else { return }
            fetchMoreMovies()
        case .tv:
            guard tvShows.count < totalTVShowsCount else { return }
            fetchMoreTVShows()
        case .people:
            guard people.count < totalPeopleCount else { return }
            fetchMorePeople()
        }
    }
    
    // MARK: - API 호출하여 추가 데이터 가져오기
    private func fetchMoreMovies() {
        moviePage += 1
        Task {
            do {
                let moreMovies = try await NetworkManager.shared.searchMovie(with: currentQuery, page: moviePage)
                DispatchQueue.main.async {
                    self.movies.append(contentsOf: moreMovies.results)
                    self.updateLoadMoreStatus()
                }
            } catch {
                print("❌ 추가 영화 로드 실패: \(error.localizedDescription)")
            }
        }
    }
    
    private func fetchMoreTVShows() {
        tvPage += 1
        Task {
            do {
                let moreTVShows = try await NetworkManager.shared.searchTV(with: currentQuery, page: tvPage)
                DispatchQueue.main.async {
                    self.tvShows.append(contentsOf: moreTVShows.results)
                    self.updateLoadMoreStatus()
                }
            } catch {
                print("❌ 추가 TV 로드 실패: \(error.localizedDescription)")
            }
        }
    }
    
    private func fetchMorePeople() {
        peoplePage += 1
        Task {
            do {
                let morePeople = try await NetworkManager.shared.searchPerson(with: currentQuery, page: peoplePage)
                DispatchQueue.main.async {
                    self.people.append(contentsOf: morePeople.results)
                    self.updateLoadMoreStatus()
                }
            } catch {
                print("❌ 추가 인물 로드 실패: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - "더보기" 버튼 활성화 여부 업데이트
    private func updateLoadMoreStatus() {
        canLoadMoreMovies = movies.count < totalMoviesCount
        canLoadMoreTVShows = tvShows.count < totalTVShowsCount
        canLoadMorePeople = people.count < totalPeopleCount
    }
    
    // MARK: - 상태 초기화
    private func resetState() {
        moviePage = 1
        tvPage = 1
        peoplePage = 1
        
        totalMoviesCount = 0
        totalTVShowsCount = 0
        totalPeopleCount = 0
        
        canLoadMoreMovies = false
        canLoadMoreTVShows = false
        canLoadMorePeople = false
        
        movies.removeAll()
        tvShows.removeAll()
        people.removeAll()
    }
    
    
    private func translateOverviews(for media: SearchTranslatedItem) {
        switch media {
        case .movie(let movies):
            for movie in movies {
                Task {
                    let translatedText = await GoogleTranslateAPI.translateText(movie.overview ?? "정보 없음 😅")
                    DispatchQueue.main.async {
                        self.translatedMovieOverviews[movie.id] = translatedText
                    }
                }
            }
            
        case .tv(let tvs):
            for tv in tvs {
                Task {
                    let translatedText = await GoogleTranslateAPI.translateText(tv.overview ?? "정보 없음 😅")
                    DispatchQueue.main.async {
                        self.translatedTVOverviews[tv.id] = translatedText
                    }
                }
            }
        }
    }
    
    private func fetchGenre(for media: SearchTranslatedItem) {
        var newGenres: [Int: [String]] = [:] // 🔹 한 번에 저장할 임시 딕셔너리

        switch media {
        case .movie(let movies):
            movies.forEach { movie in
                let genreNames = getGenresFromHomeSection(for: movie.genreIDS, contentType: .movie)
                newGenres[movie.id] = genreNames
            }
        case .tv(let tvs):
            tvs.forEach { tv in
                let genreNames = getGenresFromHomeSection(for: tv.genreIDS, contentType: .tv)
                newGenres[tv.id] = genreNames
            }
        }

        DispatchQueue.main.async {
            self.fetchedGenres.merge(newGenres) { _, new in new }
        }
    }

    
    private func getGenresFromHomeSection(for genreIDs: [Int], contentType: ContentType) -> [String] {
        switch contentType {
        case .movie:
            return genreIDs.compactMap { genreID in
                HomeViewController.movieGenres.first { $0.id == genreID }?.name
            }
        case .tv:
            return genreIDs.compactMap { genreID in
                HomeViewController.tvGenres.first {  $0.id == genreID }?.name
            }
        case .people:
            return []
        }
    }
}

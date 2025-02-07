//
//  DetailViewController.swift
//  MovieClip
//
//  Created by 권정근 on 2/7/25.
//

import UIKit

class DetailViewController: UIViewController {
    
    // MARK: - Variable
    private let contentID: Int
    private let contentType: ContentType
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemRed
        fetchContentDetail()
        
    }
    
    // ✅ 생성자에서 `id`와 `type`을 전달받음
    init(contentID: Int, contentType: ContentType) {
        self.contentID = contentID
        self.contentType = contentType
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Function
    private func fetchContentDetail() {
        Task {
            do {
                switch contentType {
                case .movie:
                    let movieDetail = try await NetworkManager.shared.getMovieDetailInfo(movieID: contentID)
                    configure(with: movieDetail) // ✅ UI 업데이트
                case .tv:
                    let tvDetail = try await NetworkManager.shared.getTVDetailInfo(tvID: contentID)
                    configure(with: tvDetail)
                case .people:
                    let peopleDetail = try await NetworkManager.shared.getPeopleDetailInfo(peopleID: contentID)
                    configure(with: peopleDetail)
                    
                }
            }
        }
    }
    
    // ✅ UI를 업데이트하는 메서드
    private func configure(with movie: MovieDetailInfoWelcome) {
        print("🎬 영화 제목: \(movie.title)")
        // 여기서 UI 업데이트
    }
    
    private func configure(with tv: TVDetailInfoWelcome) {
        print("📺 TV 쇼 제목: \(tv.name)")
        // 여기서 UI 업데이트
    }
    
    private func configure(with people: PeopleDetailInfoWelcome) {
        print("🕺 배우 이름: \(people.name)")
        // 여기서 UI 업데이트
    }
}



// ✅ 영화 및 TV 타입을 구분할 enum 추가
enum ContentType {
    case movie
    case tv
    case people
}

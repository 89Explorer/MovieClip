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
    
    
    // MARK: - UI Component
    private let detailView: DetailView = {
        let view = DetailView()
        return view
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        configureConstraints()
        
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
        activityIndicator.startAnimating() // ✅ 로딩 시작
        
        Task {
            do {
                switch contentType {
                case .movie:
                    let movieDetail = try await NetworkManager.shared.getMovieDetailInfo(movieID: contentID)
                    DispatchQueue.main.async {
                        self.configure(with: movieDetail) // ✅ UI 업데이트
                        self.activityIndicator.stopAnimating() // ✅ 데이터 로드 후 로딩 숨김
                    }
                case .tv:
                    let tvDetail = try await NetworkManager.shared.getTVDetailInfo(tvID: contentID)
                    DispatchQueue.main.async {
                        self.configure(with: tvDetail)
                        self.activityIndicator.stopAnimating() // ✅ 데이터 로드 후 로딩 숨김
                    }
                case .people:
                    let peopleDetail = try await NetworkManager.shared.getPeopleDetailInfo(peopleID: contentID)
                    DispatchQueue.main.async {
                        self.configure(with: peopleDetail)
                        self.activityIndicator.stopAnimating() // ✅ 데이터 로드 후 로딩 숨김
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                }
                print("❌ 데이터 로드 실패: \(error)")
            }
        }
    }
    
    // ✅ UI를 업데이트하는 메서드
    private func configure(with movie: MovieDetailInfoWelcome) {
        print("🎬 영화 제목: \(movie.title)")
        // 여기서 UI 업데이트
        self.detailView.configure(movie)
    }
    
    private func configure(with tv: TVDetailInfoWelcome) {
        print("📺 TV 쇼 제목: \(tv.name)")
        // 여기서 UI 업데이트
        self.detailView.configure(tv)
    }
    
    private func configure(with people: PeopleDetailInfoWelcome) {
        print("🕺 배우 이름: \(people.name)")
        // 여기서 UI 업데이트
    }
    
    
    // MARK: - Layouts
    private func configureConstraints() {
        view.addSubview(detailView)
        view.addSubview(activityIndicator)

        detailView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            detailView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            detailView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            detailView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            detailView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

}



// ✅ 영화 및 TV 타입을 구분할 enum 추가
enum ContentType {
    case movie
    case tv
    case people
}

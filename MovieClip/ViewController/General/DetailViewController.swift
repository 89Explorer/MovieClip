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
    
    // 영화, TV, 배우 데이터 저장
    private var contentDetail: ContentDetail?
    
    // 상세페이지의 헤더뷰
    private var detailHeaderView: DetailHeaderView?
    
    // 테이블의 섹션 헤더
    private var detailTableSection: [String] = ["Overview", "Top Billed Cast", "Videos", "Posters", "Recommendations"]
    
    // 영화 캐스팅 정보 저장
    private var movieTopBilledCastInfo: CastingList?
    
    // 비디오 섹션 데이터 저장
    private var mediaVideos: [VideoInfoResult] = []
    
    // 이미지 섹션 데이터 저장
    private var mediaPosters: [PosterInfoBackdrop] = []
    
    
    // MARK: - UI Component
    private let detailTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        return tableView
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
        
        view.addSubview(detailTableView)
        fetchContentDetail()
        setupTableViewDelegate()
        
        
        // ✅ 높이 자동 조절 설정
        detailTableView.estimatedRowHeight = 100  // 임의의 예상 높이 설정
        
        navigationItem.title = "상세페이지"
        navigationItem.titleView?.tintColor = .white
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // 테이블 뷰 적용
        detailTableView.frame = view.bounds
    }
    
    /// ✅ 생성자에서 `id`와 `type`을 전달받음
    init(contentID: Int, contentType: ContentType) {
        self.contentID = contentID
        self.contentType = contentType
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Function
    /// 테이블 헤더뷰 설정
    private func detailTableHeaderView() {
        detailHeaderView = DetailHeaderView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 350))
        detailTableView.tableHeaderView = detailHeaderView
        detailHeaderView?.delegate = self
    }
    
    /// 델리게이트 설정
    private func setupTableViewDelegate() {
        detailTableView.delegate = self
        detailTableView.dataSource = self
        detailTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        detailTableView.register(OverviewTableViewCell.self, forCellReuseIdentifier: OverviewTableViewCell.reuseIdentifier)
        detailTableView.register(TopBilledCastTableViewCell.self, forCellReuseIdentifier: TopBilledCastTableViewCell.reuseIdentifier)
        detailTableView.register(MediaTableViewCell.self, forCellReuseIdentifier: MediaTableViewCell.reuseIdentifier)
    }
    
    /// init으로 받아온 데이터를 통해 API 요청
    private func fetchContentDetail() {
        Task {
            do {
                // ✅ switch 문에서 데이터를 fetchedDetail 변수에 저장하고, 이후 한 번만 UI 업데이트를 수행
                var fetchedDetail: ContentDetail?
                var fetchedGenres: [String] = []  // 장르 저장 변수
                var castingList: TopBilledCastInfoWelcome?  // 출연진 목록 저장
                var videoInfo: VideoInfoWelcome?
                var posterInfo: PosterInfoWelcome?
                
                switch contentType {
                case .movie:
                    let movieDetail = try await NetworkManager.shared.getMovieDetailInfo(movieID: contentID)
                    fetchedDetail = .movie(movieDetail)
                    fetchedGenres = getGenresFromHomeSection(for: contentID)
                    castingList = try await  NetworkManager.shared.getMovieCastInfo(contentID: contentID)
                    
                    videoInfo = try await NetworkManager.shared.getMovieVideoInfo(contentID: contentID)
                    posterInfo = try await NetworkManager.shared.getMoviePosterInfo(contentID: contentID)
                    
                case .tv:
                    let tvDetail = try await NetworkManager.shared.getTVDetailInfo(tvID: contentID)
                    fetchedDetail = .tv(tvDetail)
                    fetchedGenres = getGenresFromHomeSection(for: contentID)
                    castingList = try await NetworkManager.shared.getTVCastInfo(contentID: contentID)
                    
                    videoInfo = try await NetworkManager.shared.getTvVideoInfo(contentID: contentID)
                    posterInfo = try await NetworkManager.shared.getTvPosterInfo(contentID: contentID)
                    
                case .people:
                    let peopleDetail = try await NetworkManager.shared.getPeopleDetailInfo(peopleID: contentID)
                    fetchedDetail = .people(peopleDetail)
                    fetchedGenres = getGenresFromHomeSection(for: contentID)
                }
                
                DispatchQueue.main.async {
                    self.detailTableHeaderView()   // 헤더뷰 생성
                    
                    // ✅ API 요청 실패 시 UI 업데이트 방지
                    guard let contentDetail = fetchedDetail else { return }
                    self.contentDetail = contentDetail
                    
                    // ✅ 'CastingList'를 'switch' 문을 통해 저장
                    switch contentDetail {
                    case .movie:
                        if let castingList = castingList {
                            self.movieTopBilledCastInfo = .movie(castingList)
                        }
                        
                        self.mediaVideos = videoInfo?.results ?? []    // ✅ 비디오 데이터 저장
                        self.mediaPosters = posterInfo?.posters ?? [] // ✅ 포스터 데이터 저장
                        
                    case .tv:
                        if let castingList = castingList {
                            self.movieTopBilledCastInfo = .tv(castingList)
                        }
                        
                        self.mediaVideos = videoInfo?.results ?? []    // ✅ 비디오 데이터 저장
                        self.mediaPosters = posterInfo?.posters ?? [] // ✅ 포스터 데이터 저장
                        
                    case .people:
                        break
                    }
                    
                    
                    switch contentDetail {
                    case .movie(let movieDetail):
                        self.detailHeaderView?.configure(movieDetail, genres: fetchedGenres)
                    case .tv(let tvDetail):
                        self.detailHeaderView?.configure(tvDetail, genres: fetchedGenres)
                    case .people(let peopleDetail):
                        self.detailHeaderView?.configure(peopleDetail)
                        
                    }
                    
                    self.detailTableView.reloadData()   // ✅ 데이터 로드되면 업데이트
                    
                }
            } catch {
                print("❌ 데이터 로드 실패1: \(error)")
            }
        }
    }
    
    /// 🚗 홈 뷰컨틀롤러 내 homeSection에서 genre 가져오기
    private func getGenresFromHomeSection(for contentID: Int) -> [String] {
        for section in HomeViewController.homeSections {
            switch section {
            case .trendingMovies(let movies):
                if let movie = movies.first(where: { $0.id == contentID }) {
                    return movie.genreNames ?? []  // ✅ 영화의 장르 변환
                }
            case .trendingTVs(let tv):
                if let tv = tv.first(where: { $0.id == contentID}) {
                    return tv.genreNames ?? []     // ✅ tv의 장르 변환
                }
            case .trendingPeoples:
                return []   // ✅ 배우는 장르가 없으므로 패스
            }
        }
        return []
    }
}


// MARK: - Extension: UITableViewDelegate, UITableViewDataSource
extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return DetailSection.allCases.count
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // ✅ 현재 섹션 타입 가져오기
        let sectionType = DetailSection.allCases[indexPath.section]
        
        switch sectionType {
            
        case .overview:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: OverviewTableViewCell.reuseIdentifier, for: indexPath) as? OverviewTableViewCell else { return UITableViewCell() }
            if let contentDetail = contentDetail {
                cell.configure(with: contentDetail)
            }
            return cell
            
        case .actor:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TopBilledCastTableViewCell.reuseIdentifier, for: indexPath) as? TopBilledCastTableViewCell else { return UITableViewCell() }
            
            switch contentType {
            case .movie:
                if let castingInfo = movieTopBilledCastInfo {
                    cell.configure(with: castingInfo)
                }
            case .tv:
                if let castingInfo = movieTopBilledCastInfo {
                    cell.configure(with: castingInfo)
                }
            case .people:
                break
            }
            return cell
            
        case .video:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MediaTableViewCell.reuseIdentifier, for: indexPath) as? MediaTableViewCell else { return UITableViewCell() }
            
            switch contentType {
            case .movie, .tv:
                if contentType == .movie || contentType == .tv {
                    cell.configure(with: .video(mediaVideos), type: .video)
                }
                
            case .people:
                break
            }
            return cell
            
        case .poster:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MediaTableViewCell.reuseIdentifier, for: indexPath) as? MediaTableViewCell else { return UITableViewCell() }
            
            switch contentType {
            case .movie, .tv:
                if contentType == .movie || contentType == .tv {
                    cell.configure(with: .poster(mediaPosters), type: .poster)
                }
            case .people:
                break
            }
            
            return cell
            
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = "Test"
            cell.backgroundColor = .white
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //return UITableView.automaticDimension
        let sectionType = DetailSection.allCases[indexPath.section]
        
        switch sectionType {
        case .video:
            return 130 // ✅ 비디오 컬렉션 뷰 높이
        case .poster:
            return 250 // ✅ 포스터 컬렉션 뷰 높이
        default:
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 50 : 40 // ✅ 첫 번째 섹션의 헤더 높이를 50으로 설정
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        header.textLabel?.frame = CGRect(x: header.bounds.origin.x + 20, y: header.bounds.origin.y, width: 100, height: header.bounds.height)
        header.textLabel?.textColor = .white
        header.textLabel?.text = header.textLabel?.text?.capitalizeFirstLetter()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return detailTableSection[section]
    }

}


// MARK: - Extension: DetailHeaderViewDelegate
extension DetailViewController: DetailHeaderViewDelegate {
    func didTapTrailerButton(title: String) {
        let trailerVC = TrailerViewController(trailerTitle: title)
        present(trailerVC, animated: true)
    }
}


// 📌 사용자가 선택한 콘텐츠 유형을 구분 (API 요청용)
enum ContentType {
    case movie
    case tv
    case people
}


// 📌 API 응답 데이터를 저장 (화면에 표시할 정보)
enum ContentDetail {
    case movie(MovieDetailInfoWelcome)
    case tv(TVDetailInfoWelcome)
    case people(PeopleDetailInfoWelcome)
}

// 📌 detailTableView 섹션 관리
enum DetailSection: CaseIterable {
    case overview
    case actor
    case video
    case poster
    case similar
}


enum CastingList {
    case movie(TopBilledCastInfoWelcome)
    case tv(TopBilledCastInfoWelcome)
    case people
}



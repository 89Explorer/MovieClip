//
//  HomeViewController.swift
//  MovieClip
//
//  Created by 권정근 on 2/4/25.
//

import UIKit

class HomeViewController: UIViewController {
    
    // MARK: - Variables
    /// 테이블의 섹션별 데이터를 static 프로퍼티로 선언
    static var homeSections: [HomeSection] = []
    private var homeHeaderRandomItem: MovieResult?
    
    private var homeFeedTableSection: [String] = ["Trending Movie", "Trending TV", "Trending People"]
    
    // MARK: - UI Component
    private let homeFeedTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    private var headerView: HomeTableHeaderView?
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        view.addSubview(homeFeedTableView)
        
        setupTableViewDelegate()
        homeFeedTableHeaderView()
        self.fetchMediaData()
        
        Task {
            do {
                let movieDetail = try await NetworkManager.shared.getMovieDetailInfo(movieID: 1212142)
                print("🎬 영화 제목: \(movieDetail.title)")
                print("📅 개봉일: \(movieDetail.releaseDate)")
                print("⭐ 평점: \(movieDetail.voteAverage)")
            } catch {
                print("🚨 영화 정보를 불러오는 데 실패했습니다: \(error)")
            }
        }
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // 테이블 뷰 적용
        homeFeedTableView.frame = view.bounds
    }
    
    
    // MARK: - Functions
    /// API에서 데이터를 받아와 homeSections에 저장
    private func fetchMediaData() {
        Task {
            do {
                // 1. 트렌딩 영화 목록 가져오기
                var trendingMovies = try await NetworkManager.shared.getTrendingMovies()
                
                // 2. 영화 장르 목록 가져오기
                let movieGenres = try await NetworkManager.shared.getMovieGenre()
                
                // 3. 각 영화의 genreIds를 genreNames로 변환
                for i in 0..<trendingMovies.count {
                    let movie = trendingMovies[i]
                    let matchedGenres = movie.genreIDS.compactMap { genreId in
                        movieGenres.first(where: { $0.id == genreId })?.name
                    }
                    // 장르 이름 저장
                    trendingMovies[i].genreNames = matchedGenres
                }
                
                
                // 트렌딩 TV 목록 가져오기
                var trendingTVs = try await NetworkManager.shared.getTrendingTVs()
                
                // 트렌딩 TV 장르 목록 가져오기
                let tvGenres = try await NetworkManager.shared.getTVGenre()
                
                // 각 TV의 genreIds를 genreNames로 변환
                for i in 0..<trendingTVs.count {
                    let tv = trendingTVs[i]
                    let matchedGenres = tv.genreIDS.compactMap { genreId in
                        if let genre = tvGenres.first(where: { $0.id == genreId }) {
                            return genreTranslation[genre.name] ?? genre.name   // ✅ 한글 변환 적용
                        }
                        return nil
                    }
                    // 장르 이름 저장
                    trendingTVs[i].genreNames = matchedGenres
                }
                
                
                // 트렌딩 배우 목록 가져오기
                let trendingPeoples = try await NetworkManager.shared.getTrendingPeoples()
                
                
                // 트렌딩 all 목록에서 랜덤 1개의 정보 가져오기
                let trendingAll = try await NetworkManager.shared.getRandomTrendingMovie()
                
                
                // HomeViewController의 데이터 업데이트
                HomeViewController.homeSections = [
                    .trendingMovies(trendingMovies),
                    .trendingTVs(trendingTVs),
                    .trendingPeoples(trendingPeoples),
                ]
                
                DispatchQueue.main.async {
                    self.homeFeedTableView.reloadData()
                    self.headerView?.configure(trendingAll)   // ✅ HeaderView 업데이트
                }
            } catch {
                print("Failed to fetch data: \(error)")
            }
        }
    }
    
    /// 테이블뷰 델리게이트 설정
    private func setupTableViewDelegate() {
        homeFeedTableView.delegate = self
        homeFeedTableView.dataSource = self
        homeFeedTableView.register(HomeFeedTableViewCell.self, forCellReuseIdentifier: HomeFeedTableViewCell.reuseIdentifier)
        
        homeFeedTableView.rowHeight = UITableView.automaticDimension
        homeFeedTableView.estimatedRowHeight = 350
    }
    
    /// 테이블 헤더뷰 설정
    private func homeFeedTableHeaderView() {
        headerView = HomeTableHeaderView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 350))
        homeFeedTableView.tableHeaderView = headerView
    }
    
}

// MARK: - Extension: TableView Delegate
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return HomeViewController.homeSections.isEmpty ? 0 : HomeViewController.homeSections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1   // 각 섹션에 컬렉션뷰 1개만 존재
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeFeedTableViewCell.reuseIdentifier, for: indexPath) as? HomeFeedTableViewCell else { return UITableViewCell() }
        
        // 섹션 인덱스 전달
        cell.sectionIndex = indexPath.section
        
        return cell
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
        return homeFeedTableSection[section]
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let defaultOffset = view.safeAreaInsets.top
        let offset = scrollView.contentOffset.y + defaultOffset
        
        navigationController?.navigationBar.transform = .init(translationX: 0, y: -offset)
    }
}


// MARK: - Enum
enum HomeSection {
    case trendingMovies([MovieResult])
    case trendingTVs([TVResult])
    case trendingPeoples([PeopleResult])
}

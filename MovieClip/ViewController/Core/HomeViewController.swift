//
//  HomeViewController.swift
//  MovieClip
//
//  Created by 권정근 on 2/4/25.
//

import UIKit
import FirebaseAuth
import Combine

class HomeViewController: UIViewController {
    
    // MARK: - Variables
    private var viewModel = HomeViewModel()
    private var cancelable: Set<AnyCancellable> = []
    
    /// 테이블의 섹션별 데이터를 static 프로퍼티로 선언
    static var homeSections: [HomeSection] = []
    
    // ✅ 영화 및 TV 장르를 저장할 'static' 프로퍼티 추가
    static var movieGenres: [MovieGenre] = []
    static var tvGenres: [TVGenre] = []
    
    
    private var homeHeaderRandomItem: MovieResult?
    
    private var homeFeedTableSection: [String] = ["Trending Movie", "Trending TV", "Trending People"]
    
    // MARK: - UI Component
    private let homeFeedTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.isUserInteractionEnabled = true
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
        
        bindView()
        
        // ✅ 네비에기션 타이틀 설정
        navigationItem.title = "Home"
        navigationController?.navigationBar.prefersLargeTitles = true
        configureNavigationBarAppearance()
        
        self.fetchMediaData()
        
        let backBarButton = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        backBarButton.tintColor = .systemBlue
        self.navigationItem.backBarButtonItem = backBarButton
        
        // 로그아웃 버튼
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "rectangle.portrait.and.arrow.right"), style: .plain, target: self, action: #selector(didTapSignOut))
    
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // 테이블 뷰 적용
        homeFeedTableView.frame = view.bounds
    }
    
    
    // MARK: - Functions
    private func configureNavigationBarAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        
        // ✅ 네비게이션 바 배경 검은색
        appearance.backgroundColor = .black
        
        // ✅ 큰 타이틀 색상 흰색
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        // ✅ 일반 타이틀 색상 흰색
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    /// API에서 데이터를 받아와 homeSections에 저장
    private func fetchMediaData() {
        Task {
            do {
                // 1. 트렌딩 영화 목록 가져오기
                var trendingMovies = try await NetworkManager.shared.getTrendingMovies()
                //dump(trendingMovies)
                
                // 2. 영화 장르 목록 가져오기
                let movieGenres = try await NetworkManager.shared.getMovieGenre()
                HomeViewController.movieGenres = movieGenres
                
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
                HomeViewController.tvGenres = tvGenres
                
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
                //let trendingPeoples = try await NetworkManager.shared.getTrendingPeoples()
                
                
                // 트렌딩 all 목록에서 랜덤 1개의 정보 가져오기
                let trendingAll = try await NetworkManager.shared.getRandomTrendingMovie()
                
                
                // HomeViewController의 데이터 업데이트
                HomeViewController.homeSections = [
                    .trendingMovies(trendingMovies),
                    .trendingTVs(trendingTVs),
                    //.trendingPeoples(trendingPeoples),
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
        headerView?.delegate = self
    }
    
    private func bindView() {
        // 회원정보 가져오기 
        viewModel.retrieveUser()
        
        viewModel.$user
            .sink { [weak self] user in
                guard let user = user else { return }
                if !user.isUserOnboarded {
                    self?.completeUserOnboarding()
                }
            }
            .store(in: &cancelable)
    }
    
    func completeUserOnboarding() {
        let profileDataFormVC = ProfileDataFormViewController()
        present(profileDataFormVC, animated: true)
    }
    
    
    // MARK: - Action
    @objc private func didTapSignOut() {
        do {
            try Auth.auth().signOut()
            
            // ✅ 기존의 모든 화면을 닫고, OnboardingViewController로 이동
            self.view.window?.rootViewController?.dismiss(animated: true, completion: {
                if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
                    sceneDelegate.window?.rootViewController = UINavigationController(rootViewController: OnboardingViewController())
                }
            })
        } catch {
            print("로그아웃 실패: \(error.localizedDescription)")
        }
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
        cell.delegate = self // ✅ 델리게이트 설정
        
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
    
    
    //    func scrollViewDidScroll(_ scrollView: UIScrollView) {
    //        let defaultOffset = view.safeAreaInsets.top
    //        let offset = scrollView.contentOffset.y + defaultOffset
    //
    //        navigationController?.navigationBar.transform = .init(translationX: 0, y: -offset)
    //    }
}

// MARK: - Extension: HomeFeedTableViewCellDelegate
extension HomeViewController: HomeFeedTableViewCellDelegate {
    
    func homeFeedTableViewCellDidSelectItem(_ cell: HomeFeedTableViewCell, section: Int, index: Int) {
        
        // ✅ 확인하기 위함
        // print("✅ [홈 뷰 컨트롤러] 선택된 섹션: \(section), 아이템: \(index)")
        
        let sectionData = HomeViewController.homeSections[section]
        
        switch sectionData {
        case .trendingMovies(let movies):
            let selectedMovie = movies[index]
            let detailVC = DetailViewController(contentID: selectedMovie.id, contentType: .movie)
            navigationController?.pushViewController(detailVC, animated: true)
            
        case .trendingTVs(let tvShows):
            let selectedTV = tvShows[index]
            let detailVC = DetailViewController(contentID: selectedTV.id, contentType: .tv)
            navigationController?.pushViewController(detailVC, animated: true)
            
            //        case .trendingPeoples(let people):
            //            let selectedPeople = people[index]
            //            let detailVC = DetailViewController(contentID: selectedPeople.id, contentType: .people)
            //            navigationController?.pushViewController(detailVC, animated: true)
            //
        }
    }
}


// MARK: - Enum
enum HomeSection {
    case trendingMovies([MovieResult])
    case trendingTVs([TVResult])
    //case trendingPeoples([PeopleResult])
}



extension HomeViewController: HomeTableHeaderviewDelegate {
    func didTapHomeTableHeader(contentID: Int, contentType: ContentType) {
        let detailVC = DetailViewController(contentID: contentID, contentType: contentType)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

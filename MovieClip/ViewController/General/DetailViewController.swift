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
    
    
    // MARK: - UI Component
    private let detailTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        return tableView
    }()
    
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
        
        view.addSubview(detailTableView)
        fetchContentDetail()
        setupTableViewDelegate()
        
        navigationItem.title = "상세페이지"
        navigationController?.navigationBar.tintColor = .white
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // 테이블 뷰 적용
        detailTableView.frame = view.bounds
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
    
    
    // 델리게이트 설정
    private func setupTableViewDelegate() {
        detailTableView.delegate = self
        detailTableView.dataSource = self
        detailTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    // init으로 받아온 데이터를 통해 API 요청
    private func fetchContentDetail() {
        Task {
            do {
                switch contentType {
                case .movie:
                    let movieDetail = try await NetworkManager.shared.getMovieDetailInfo(movieID: contentID)
                    self.contentDetail = .movie(movieDetail)
                    dump("현재 선택된 🎥 영화: \(movieDetail.title)")
                case .tv:
                    let tvDetail = try await NetworkManager.shared.getTVDetailInfo(tvID: contentID)
                    self.contentDetail = .tv(tvDetail)
                    dump("현재 선택된 📺 tv: \(tvDetail.name)")
                case .people:
                    let peopleDetail = try await NetworkManager.shared.getPeopleDetailInfo(peopleID: contentID)
                    self.contentDetail = .people(peopleDetail)
                    dump("현재 선택된 🧍 사람: \(peopleDetail.name)")
                }
                
                DispatchQueue.main.async {
                    self.detailTableView.reloadData()   // ✅ 데이터 로드되면 업데이트
                }
            } catch {
                print("❌ 데이터 로드 실패: \(error)")
            }
        }
    }
}

extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "Test"
        cell.backgroundColor = .white
        return cell
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

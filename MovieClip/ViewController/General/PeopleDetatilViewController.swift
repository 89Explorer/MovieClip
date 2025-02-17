//
//  PeopleDetatilViewController.swift
//  MovieClip
//
//  Created by 권정근 on 2/13/25.
//

import UIKit

class PeopleDetatilViewController: UIViewController {
    
    // MARK: - Variable
    private let peopleID: Int
    
    // ✅ 배우 절보 저장
    private var peopleDetail: PeopleDetailInfoWelcome?
    
    private var peopleDetailHeaderView: PeopleDetailHeaderView?
    
    private var socialLinks: ExternalID?    // ✅ 소셜 데이터 저장
    
    private var detailSection: [String] = ["Overview", "Credits"]
    
    private var expandedCells: Set<Int> = [] // ✅ 확장된 셀 저장
    
    private var koreanBio: String = ""
    
    private var movieCredits: [MovieCreditCast] = []
    private var tvCredits: [TVCreditCast] = []
    
    private var creditType: CreditType = .movie
    
    
    // MARK: - UI Component
    private let peopleTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    
    // MARK: - Init
    init(peopleID: Int) {
        self.peopleID = peopleID
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        view.addSubview(peopleTableView)
        
        navigationItem.title = "상세페이지"
        navigationItem.titleView?.tintColor = .white
        
        // ✅ 높이 자동 조절 설정
        peopleTableView.estimatedRowHeight = 100  // 임의의 예상 높이 설정
        fetchedPeopleDetailInfo()
        setupTableViewDelegate()
        
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        peopleTableView.frame = view.bounds
    }
    
    
    // MARK: - Function
    private func fetchedPeopleDetailInfo() {
        Task {
            do {
                let peopleInfo = try await NetworkManager.shared.getPeopleDetailInfo(peopleID: peopleID)
                let socialLinks = try await NetworkManager.shared.getPeopleExternalIDs(peopleID: peopleID)
                
                let movieCredits = try await NetworkManager.shared.getMovieCredits(peopleID: peopleID)
                let tvCredits = try await NetworkManager.shared.getTVCredits(peopleID: peopleID)
                
                // ✅ biography 번역
                let translatedBio = await GoogleTranslateAPI.translateText(peopleInfo.biography ?? "정보 없음 😅")
                
                
                DispatchQueue.main.async { [self] in
                    
                    self.peopleDetail = peopleInfo
                    self.socialLinks = socialLinks
                    self.koreanBio = translatedBio
                    self.movieCredits = movieCredits.cast
                    self.tvCredits = tvCredits.cast
                    
                    guard let peopleDetail = self.peopleDetail else {
                        print("❌ no peopleDetail")
                        return
                    }
                    
                    // ✅ 데이터 로드 전에 헤더뷰를 미리 설정 (빈 상태)
                    self.configureDetailHeaderView()
                    self.peopleDetailHeaderView?.configure(with: peopleDetail, socialLinks: socialLinks)
                    
                    self.peopleTableView.reloadData()
                }
            } catch {
                print("❌ 데이터 로드 실패: \(error)")
            }
        }
    }
    
    
    private func setupTableViewDelegate() {
        peopleTableView.delegate = self
        peopleTableView.dataSource = self
        peopleTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        peopleTableView.register(PeopleOverviewTableViewCell.self, forCellReuseIdentifier: PeopleOverviewTableViewCell.reuseIdentifier)
        peopleTableView.register(CreditTableViewCell.self, forCellReuseIdentifier: CreditTableViewCell.reuseIdentifier)
    }
    
    
    private func configureDetailHeaderView() {
        if peopleDetailHeaderView == nil {
            peopleDetailHeaderView = PeopleDetailHeaderView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 250))
            peopleTableView.tableHeaderView = peopleDetailHeaderView // ✅ 초기 빈 Header 설정
        }
    }
    
}


// MARK: - Extension
extension PeopleDetatilViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return PeopleDetailSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let sectionType = PeopleDetailSection.allCases[indexPath.section]
        
        switch sectionType {
            
        case .overview:
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: PeopleOverviewTableViewCell.reuseIdentifier, for: indexPath) as? PeopleOverviewTableViewCell else { return UITableViewCell() }
        
            let isExpanded = expandedCells.contains(indexPath.row)    // ✅ 확장 여부 확인
            
            if koreanBio.count != 0 {
                cell.configure(with: koreanBio, isExpanded: isExpanded)
            } else {
                cell.configure(with: "정보 없음 😅", isExpanded: isExpanded)
            }
        
            cell.delegate = self
            
            return cell
            
        case .filmography:
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CreditTableViewCell.reuseIdentifier, for: indexPath) as? CreditTableViewCell else { return UITableViewCell() }
            
            switch creditType {
            case .movie:
                cell.configure(with: .movie(movieCredits), creditType: .movie)
                cell.delegate = self
            case .tv:
                cell.configure(with: .tv(tvCredits), creditType: .tv)
                cell.delegate = self
            }
            
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        header.textLabel?.frame = CGRect(x: header.bounds.origin.x + 20, y: header.bounds.origin.y, width: 100, height: header.bounds.height)
        header.textLabel?.textColor = .white
        header.textLabel?.text = header.textLabel?.text?.capitalizeFirstLetter()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return detailSection[section]
    }
}


// MARK: - Extension: PeopleOverviewTableViewCellDelegate
extension PeopleDetatilViewController: PeopleOverviewTableViewCellDelegate {
    func didTapExpandButton(in cell: PeopleOverviewTableViewCell) {
        if let indexPath = peopleTableView.indexPath(for: cell) {
            
            if expandedCells.contains(indexPath.row) {
                expandedCells.remove(indexPath.row) // ✅ 이미 확장된 경우 제거
            } else {
                expandedCells.insert(indexPath.row) // ✅ 확장되지 않은 경우 추가
            }
            
            UIView.animate(withDuration: 0.3) {
                self.peopleTableView.reloadData()
            }
        }
    }
}


extension PeopleDetatilViewController: CreditTableViewCellDelegate {
    
    func didTapCategoryButton() {
        creditType.toggle()
        DispatchQueue.main.async {
            self.peopleTableView.reloadData()
        }

    }
    
    func didTapImage(with contentID: Int, contentType: ContentType) {
        let detailVC = DetailViewController(contentID: contentID, contentType: contentType)
        navigationController?.pushViewController(detailVC, animated: true)
    }

}


// MARK: - Enum
enum PeopleDetailSection: CaseIterable {
    case overview
    case filmography
}

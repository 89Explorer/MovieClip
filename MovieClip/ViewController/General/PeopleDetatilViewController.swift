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
    weak var delegaate: PeopleDetailViewControllerDelegate?
    
    // ✅ 배우 절보 저장
    private var peopleDetail: PeopleDetailInfoWelcome?
    private var peopleDetailHeaderView: PeopleDetailHeaderView?
    private var socialLinks: ExternalID?
    
    
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
        
        setupTableViewDelegate()        
        fetchedPeopleDetailInfo()
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
                
                
                DispatchQueue.main.async {
                    
                    self.peopleDetail = peopleInfo
                    self.socialLinks = socialLinks
                    
                    guard let peopleDetail = self.peopleDetail else {
                        print("❌ no peopleDetail")
                        return
                    }
                    self.configureDetailHeaderView()    // 헤더뷰 생성
                    
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
    }
    
    
    private func configureDetailHeaderView() {
        let headerView = PeopleDetailHeaderView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 250))
        peopleTableView.tableHeaderView = headerView
        guard let peopleInfo = peopleDetail,
              let socialLinks = socialLinks
        else { return }
        headerView.configure(with: peopleInfo, socialLinks: socialLinks)
    }
}


// MARK: - Extension
extension PeopleDetatilViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "Test"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}


// MARK: - Protocol
protocol PeopleDetailViewControllerDelegate: AnyObject {
    func didTapPeopleImage(peopleID: Int)
}

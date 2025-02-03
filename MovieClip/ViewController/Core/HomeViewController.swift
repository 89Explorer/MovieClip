//
//  HomeViewController.swift
//  MovieClip
//
//  Created by 권정근 on 2/4/25.
//

import UIKit

class HomeViewController: UIViewController {

    
    // MARK: - UI Component
    private let homeFeedTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        configureConstraints()
        setupTableView()
    }
    
    // MARK: - Functions
    /// 테이블뷰 델리게이트 설정
    private func setupTableView() {
        homeFeedTableView.delegate = self
        homeFeedTableView.dataSource = self
        homeFeedTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    // MARK: - Layouts
    /// 제약조건
    private func configureConstraints() {
        view.addSubview(homeFeedTableView)
        
        homeFeedTableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            homeFeedTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            homeFeedTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            homeFeedTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            homeFeedTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
            
        ])
    }
}

// MARK: - Extension: TableView Delegate
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "Test"
        return cell 
    }
}

//
//  SearchViewController.swift
//  MovieClip
//
//  Created by 권정근 on 2/4/25.
//

import UIKit

class SearchViewController: UIViewController {
    
    
    // MARK: - UI Component
    private let searchController = UISearchController(searchResultsController: SearchResultViewController())
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        configureSearchController()
        configureNavigationBarAppearance()
        searchController.searchResultsUpdater = self
        
    }
    
    
    // MARK: - Function
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
        
        // ✅ 네비에기션 타이틀 설정
        navigationItem.title = "Search"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    
    private func configureSearchController() {
        searchController.searchBar.placeholder = "Search for a Movie or Tv or Person"
        searchController.searchBar.searchBarStyle = .minimal
        
        
        // ✅ 검색 컨트롤러 추가
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        
        // ✅ 스크롤 시에도 검색창이 사라지지 않도록 설정
        navigationItem.hidesSearchBarWhenScrolling = false
        
        
        // ✅ 서치바의 글색상 및 돋보기 색상 변경
        let textFieldInsideSearchBar = navigationItem.searchController?.searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = .white
        textFieldInsideSearchBar?.leftView?.tintColor = .white
    }
}


extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
        let searchBar = searchController.searchBar
        
        guard let keyword = searchBar.text,
              !keyword.trimmingCharacters(in: .whitespaces).isEmpty,
              keyword.trimmingCharacters(in: .whitespaces).count >= 2,
              
                let resultController = searchController.searchResultsController as? SearchResultViewController
        else { return }
    }
}

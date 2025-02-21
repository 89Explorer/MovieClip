//
//  SearchViewController.swift
//  MovieClip
//
//  Created by 권정근 on 2/4/25.
//

import UIKit
import Combine

class SearchViewController: UIViewController {
    
    // MARK: - Variable
    private let viewModel: SearchViewModel = SearchViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    
    // MARK: - UI Component
    private let searchController: UISearchController
    private let resultViewController: SearchResultViewController
    
    
    // MARK: - Init
    init() {
        self.resultViewController = SearchResultViewController(viewModel: viewModel)
        self.searchController = UISearchController(searchResultsController: resultViewController)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        configureSearchController()
        configureNavigationBarAppearance()
        
        //searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
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


extension SearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let keyword = searchBar.text,
              !keyword.trimmingCharacters(in: .whitespaces).isEmpty,
              keyword.trimmingCharacters(in: .whitespaces).count >= 2
        else { return }
        
        viewModel.search(query: keyword)
        searchBar.resignFirstResponder()
    }
}

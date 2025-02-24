//
//  SearchResultViewController.swift
//  MovieClip
//
//  Created by 권정근 on 2/21/25.
//

import UIKit
import Combine

class SearchResultViewController: UIViewController {
    
    // MARK: - Variable
    private let viewModel: SearchViewModel
    private var cancellables = Set<AnyCancellable>()
    private var dataSource: UICollectionViewDiffableDataSource<SearchSection, SearchItem>?
    
    
    // MARk: - UI Component
    private var searchResultCollectionView: UICollectionView!
    
    
    // MARK: - Init
    init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARk: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemRed
        
        searchResultCollectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompostionalLayout())
        searchResultCollectionView.backgroundColor = .black
        searchResultCollectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        searchResultCollectionView.showsVerticalScrollIndicator = false
        
        searchResultCollectionView.register(SearchResultCell.self, forCellWithReuseIdentifier: SearchResultCell.reuseIdentifier)
        searchResultCollectionView.register(SearchFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: SearchFooterView.reuseIdentifier)
        searchResultCollectionView.register(SearchSectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SearchSectionHeader.reuseIdentifier)
        
        
        view.addSubview(searchResultCollectionView)
        
        bindViewModel()
        createDataSource()
        
        searchResultCollectionView.delegate = self
        searchResultCollectionView.isUserInteractionEnabled = true
    }
    
    
    // MARK: - Function
    private func bindViewModel() {
        
        viewModel.$movies
            .sink { [weak self] _  in
                self?.reloadData()
            }
            .store(in: &cancellables)
        
        viewModel.$tvShows
            .sink { [weak self] _ in
                self?.reloadData()
            }
            .store(in: &cancellables)
        
        viewModel.$people
            .sink { [weak self] _ in
                self?.reloadData()
            }
            .store(in: &cancellables)
        
        viewModel.$canLoadMoreMovies
            .sink { [weak self] _ in
                self?.reloadData()
            }
            .store(in: &cancellables)
        
        viewModel.$canLoadMoreTVShows
            .sink { [weak self] _ in
                self?.reloadData()
            }
            .store(in: &cancellables)
        
        viewModel.$canLoadMorePeople
            .sink { [weak self] _  in
                self?.reloadData()
            }
            .store(in: &cancellables)
    }
    
    
    private func reloadData() {
        
        var snapshot = NSDiffableDataSourceSnapshot<SearchSection, SearchItem>()
        
        if !viewModel.movies.isEmpty {
            snapshot.appendSections([.movie])
            snapshot.appendItems(viewModel.movies.map { SearchItem.movie($0) }, toSection: .movie)
        }
        
        if !viewModel.tvShows.isEmpty {
            snapshot.appendSections([.tv])
            snapshot.appendItems(viewModel.tvShows.map { SearchItem.tv($0) }, toSection: .tv)
        }
        
        if !viewModel.people.isEmpty {
            snapshot.appendSections([.people])
            snapshot.appendItems(viewModel.people.map { SearchItem.people($0) }, toSection: .people)
        }
        
        dataSource?.apply(snapshot, animatingDifferences: true)
        
    }
    
    
    
    private func configure<T: SelfConfiguringSearchCell>(_ cell: T, with model: SearchItem) {
        
        cell.configure(with: model)
        
    }
    
    
    private func createCompostionalLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { sectionIndex, _ in
            let sectionType = SearchSection.allCases[sectionIndex]
            
            switch sectionType {
            default:
                return self.createSearchResultSection()
            }
            
        }
    }
    
    private func createDataSource() {
        dataSource = UICollectionViewDiffableDataSource<SearchSection, SearchItem>(collectionView: searchResultCollectionView) { searchResultCollectionView, indexPath, item in
            
            guard let cell = searchResultCollectionView.dequeueReusableCell(withReuseIdentifier: SearchResultCell.reuseIdentifier, for: indexPath) as? SearchResultCell else { return UICollectionViewCell() }
            
            cell.setViewModel(self.viewModel)
            
            switch item {
            case .movie(let movie):
                self.configure(cell, with: .movie(movie))
            case .tv(let tv):
                self.configure(cell, with: .tv(tv))
            case .people(let person):
                self.configure(cell, with: .people(person))
            }
            
            return cell
        }
        
        dataSource?.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath in
            guard let self = self else { return UICollectionReusableView() }
            
            if kind == UICollectionView.elementKindSectionHeader {
                // ✅ 섹션 헤더 처리
                let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SearchSectionHeader.reuseIdentifier, for: indexPath) as? SearchSectionHeader
                
                let section = SearchSection.allCases[indexPath.section]
      
                header?.configure(with: section.title)
                
                return header ?? UICollectionReusableView() // 🔴 nil 반환 방지
            }
            
            if kind == UICollectionView.elementKindSectionFooter {
                // ✅ 더보기 버튼(검색 결과 전체보기) 처리
                let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SearchFooterView.reuseIdentifier, for: indexPath) as! SearchFooterView
                
                let section = SearchSection.allCases[indexPath.section]
                let canLoadMore: Bool
                
                switch section {
                case .movie: canLoadMore = self.viewModel.canLoadMoreMovies
                case .tv: canLoadMore = self.viewModel.canLoadMoreTVShows
                case .people: canLoadMore = self.viewModel.canLoadMorePeople
                }
                
                footer.isHidden = !canLoadMore // ✅ 필요 없으면 숨김
                footer.configure(with: "검색 결과 전체보기") {
                    switch section {
                    case .movie: self.viewModel.loadMore(for: .movie)
                    case .tv: self.viewModel.loadMore(for: .tv)
                    case .people: self.viewModel.loadMore(for: .people)
                    }
                }
                
                return footer
            }
            
            return UICollectionReusableView() // 🔴 nil 반환 방지
        }
        
    }
    
    
    private func createSearchResultSection() -> NSCollectionLayoutSection {
            
        // ✅ 아이템 크기 (각 셀 크기)
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.33))
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        
        // ✅ 그룹 설정 (수직 그룹)
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.93), heightDimension: .estimated(400))
        let layoutGroup = NSCollectionLayoutGroup.vertical(layoutSize: layoutGroupSize, subitems: [layoutItem])

        // ✅ 섹션 설정
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        layoutSection.interGroupSpacing = 10
        layoutSection.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)

        // ✅ "검색 결과 더 보기" 버튼 추가 (Supplementary Item - elementKindSectionFooter)
        let footerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.93), heightDimension: .estimated(50))
        let footer = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: footerSize, elementKind: UICollectionView.elementKindSectionFooter, alignment: .bottom)

        // ✅ 섹션 헤더 추가 (Supplementary Item - elementKindSectionHeader)
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(50))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)

        layoutSection.boundarySupplementaryItems = [header, footer]


        return layoutSection
    }
}


// MARK: - Extension
extension SearchResultViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        guard let selectedCategory = dataSource?.itemIdentifier(for: indexPath) else { return }
        
        let detailVC: UIViewController
        
        switch selectedCategory {
        case .movie(let movie):
            let contentID = movie.id
            detailVC = DetailViewController(contentID: contentID, contentType: .movie)
            //navigationController?.pushViewController(detailVC, animated: true)
        case .tv(let tv):
            let contentID = tv.id
            detailVC = DetailViewController(contentID: contentID, contentType: .tv)
            //navigationController?.pushViewController(detailVC, animated: true)
            
        case .people(let people):
            let contentID = people.id
            detailVC = PeopleDetatilViewController(peopleID: contentID)
            //navigationController?.pushViewController(detailVC, animated: true)
        }
        
        // ✅ 현재 navigationController가 nil인지 확인 후 push
        if let navController = self.navigationController {
            navController.pushViewController(detailVC, animated: true)
        } else {
            print("❌ navigationController가 없음! present로 대체")
            //present(UINavigationController(rootViewController: detailVC), animated: true)
            presentingViewController?.navigationController?.pushViewController(detailVC, animated: true)
        }
    }
}

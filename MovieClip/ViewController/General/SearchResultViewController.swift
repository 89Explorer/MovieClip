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

        
        view.addSubview(searchResultCollectionView)
        
        bindViewModel()
        createDataSource()
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
    
    
    
    private func configure<T: SelfConfiguringSearchCell>(_ cellType: T.Type, with model: SearchItem, for indexPath: IndexPath) -> T {
        guard let cell = searchResultCollectionView.dequeueReusableCell(withReuseIdentifier: cellType.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Unable to deque: \(cellType)")
        }
        
        cell.configure(with: model)
        
        return cell
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
            switch item {
            case .movie(let movie):
                return self.configure(SearchResultCell.self, with: .movie(movie), for: indexPath)
            case .tv(let tv):
                return self.configure(SearchResultCell.self, with: .tv(tv), for: indexPath)
            case .people(let person):
                return self.configure(SearchResultCell.self, with: .people(person), for: indexPath)
            }
        }
        
        // 더보기 버튼을 위한 Footer 설정
        dataSource?.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath in
            guard let self = self, kind == UICollectionView.elementKindSectionFooter else { return nil }
            
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SearchFooterView.reuseIdentifier, for: indexPath) as? SearchFooterView
            
            let section = SearchSection.allCases[indexPath.section]
            footer?.configure(with: section) {
                switch section {
                case .movie: self.viewModel.loadMoreMovies()
                case .tv: self.viewModel.loadMoreTVShows()
                case .people: self.viewModel.loadMorePeople()
                }
            }
            
            return footer
        }
    }
    
    
    private func createSearchResultSection() -> NSCollectionLayoutSection {
        
        // 아이템 크기
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.33))
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        //layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5)
        
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.93), heightDimension: .estimated(400))
        let layoutGroup = NSCollectionLayoutGroup.vertical(layoutSize: layoutGroupSize, subitems: [layoutItem])
        
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        layoutSection.interGroupSpacing = 10
        layoutSection.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        
        // 더보기 버튼
        let footerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.93), heightDimension: .estimated(50))
        let footer = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: footerSize, elementKind: UICollectionView.elementKindSectionFooter, alignment: .bottom)
        layoutSection.boundarySupplementaryItems = [footer]
        
        return layoutSection
    }
}

//
//  SeriesViewController.swift
//  MovieClip
//
//  Created by 권정근 on 2/4/25.
//

import UIKit

class SeriesViewController: UIViewController {
    
    // MARK: - Variable
    private var dataSource: UICollectionViewDiffableDataSource<TvTMDBData, TvResultItem>?
    private var tvCombineSection: TvCombineData = TvCombineData(combineTMDB: [])
    
    
    // MARK: - UI Component
    private var seriesCollectionView: UICollectionView!
    
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        // ✅ 네비에기션 타이틀 설정
        navigationItem.title = "TV"
        navigationController?.navigationBar.prefersLargeTitles = true
        configureNavigationBarAppearance()
        
        setupCollectionView()
        
        fetchTvs()
        createDataSource()
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
    }
    
    private func setupCollectionView() {
        seriesCollectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompositionalLayout())
        seriesCollectionView.backgroundColor = .black
        seriesCollectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        seriesCollectionView.showsVerticalScrollIndicator = false
        
        view.addSubview(seriesCollectionView)
        
        seriesCollectionView.delegate = self
        
        // 컬렉션뷰 섹션헤더 설정
        seriesCollectionView.register(TVSectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TVSectionHeader.reuseIdentifier)
        
        seriesCollectionView.register(TvFeaturedCell.self, forCellWithReuseIdentifier: TvFeaturedCell.reuseIdentifier)
        seriesCollectionView.register(TVMediumCell.self, forCellWithReuseIdentifier: TVMediumCell.reuseIdentifier)
        seriesCollectionView.register(TVSmallCell.self, forCellWithReuseIdentifier: TVSmallCell.reuseIdentifier)
    }
    
    private func configure<T: SelfConfiguringTVCell>(_ cellType: T.Type, with model: TvTMDBResult, for indexPath: IndexPath) -> T {
        
        guard let cell = seriesCollectionView.dequeueReusableCell(withReuseIdentifier: cellType.reuseIdentifier, for: indexPath) as? T else { fatalError("Unable to deque \(cellType)")}
        
        cell.configure(with: model)
        return cell
    }
    
    
    private func createDataSource() {
        dataSource = UICollectionViewDiffableDataSource<TvTMDBData, TvResultItem>(collectionView: seriesCollectionView) { collectionView, indexPath, item in
            
            let tvTMDBResult = item.tvResult
            let sectionType = self.tvCombineSection.combineTMDB[indexPath.section].type ?? .popular
            
            switch sectionType {
            case .airingToday:
                return self.configure(TvFeaturedCell.self, with: tvTMDBResult, for: indexPath)
            case .onTheAir:
                return self.configure(TVMediumCell.self, with: tvTMDBResult, for: indexPath)
            case .popular:
                return self.configure(TvFeaturedCell.self, with: tvTMDBResult, for: indexPath)
            case .topRated:
                return self.configure(TVSmallCell.self, with: tvTMDBResult, for: indexPath)
            }
        }
        
        dataSource?.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath in
            guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: TVSectionHeader.reuseIdentifier, for: indexPath) as? TVSectionHeader else { return nil }
            
            guard let firstItem = self?.dataSource?.itemIdentifier(for: indexPath) else { return nil }
            guard let section = self?.dataSource?.snapshot().sectionIdentifier(containingItem: firstItem) else { return nil }
            
            guard let sectionType = section.type else { return nil }
            
            let mainTitle = sectionType.rawValue
            let subTitle: String
            
            switch sectionType {
            case .airingToday:
                subTitle = "오늘 방영중 TV"
            case .onTheAir:
                subTitle = "현재 방영 중인 TV"
            case .popular:
                subTitle = "인기 TV"
            case .topRated:
                subTitle = "순위 별 TV"
            }
            
            sectionHeader.configure(with: mainTitle, sub: subTitle)
            return sectionHeader
        }
    }
    
    
    private func reloadData() {
        var snapshot = NSDiffableDataSourceSnapshot<TvTMDBData, TvResultItem>()
        
        // 섹션 추가
        snapshot.appendSections(tvCombineSection.combineTMDB)
        
        // 각 섹션의 결과를 TvResultItem으로 래핑하여 추가
        for tmdbData in tvCombineSection.combineTMDB {
            // 각 섹션에 명시적으로 type이 할당되어 있지 않다면 기본값(.popular) 등을 사용할 수 있음
            let items = tmdbData.results.map {
                TvResultItem(tvResult: $0, sectionType: tmdbData.type ?? .popular)
            }
            snapshot.appendItems(items, toSection: tmdbData)
        }
        
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
    
    
    private func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout {
            
            sectionIndex, layoutEnvironment in
            
            let section = self.tvCombineSection.combineTMDB[sectionIndex]
            
            switch section.type {
            case .onTheAir:
                return self.createMediumTableSection(using: section.results)
            case .topRated:
                return self.createSmaillTableSection(using: section.results)
            default:
                return self.createFeaturedSection(using: section.results)
            }
        }
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20
        layout.configuration = config
        return layout
    }
    
    // TvFeaturedCell 관련 레이아웃
    private func createFeaturedSection(using section: [TvTMDBResult]) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5)
        
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.93), heightDimension: .estimated(550))
        
        let layoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: layoutGroupSize, subitems: [layoutItem])
        
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        layoutSection.orthogonalScrollingBehavior = .groupPagingCentered
        
        // 섹션 헤더설정
        let layoutSectionHeader = createSectionHeader()
        layoutSection.boundarySupplementaryItems = [layoutSectionHeader]
        
        return layoutSection
    }
    
    
    private func createMediumTableSection(using section: [TvTMDBResult]) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.2))
        
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.93), heightDimension: .fractionalWidth(0.85))
        let layoutGroup = NSCollectionLayoutGroup.vertical(layoutSize: layoutGroupSize, subitems: [layoutItem])
        
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        layoutSection.orthogonalScrollingBehavior = .groupPagingCentered
        
        // 섹션 헤더설정
        let layoutSectionHeader = createSectionHeader()
        layoutSection.boundarySupplementaryItems = [layoutSectionHeader]
        
        
        return layoutSection
    }
    
    func createSmaillTableSection(using section: [TvTMDBResult]) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.33))
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0)
        
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.93), heightDimension: .fractionalWidth(0.8))
        let layoutGoup = NSCollectionLayoutGroup.vertical(layoutSize: layoutGroupSize, subitems: [layoutItem])

        let layoutSection = NSCollectionLayoutSection(group: layoutGoup)
        layoutSection.orthogonalScrollingBehavior = .groupPagingCentered
        
        // 섹션 헤더설정
        let layoutSectionHeader = createSectionHeader()
        layoutSection.boundarySupplementaryItems = [layoutSectionHeader]
        
        
        return layoutSection
    }
    
    func createSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let layoutSectionHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.93), heightDimension: .estimated(80))
        let layoutSectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: layoutSectionHeaderSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        
        return layoutSectionHeader
    }
    
    
    /// API 호출을 통해 외부 데이터 가져오기
    private func fetchTvs() {
        Task {
            do {
                var tvs = try await NetworkManager.shared.fetchAllTvs()
                
                for i in 0..<tvs.combineTMDB.count {
                    for j in 0..<tvs.combineTMDB[i].results.count {
                        let genreIDs = tvs.combineTMDB[i].results[j].genreIDS
                        let contentType: ContentType = .tv
                        
                        var genreNames = getGenresFromHomeSection(for: genreIDs, contentType: contentType)
                        
                        // 영어 장르명을 한글로 변환
                        genreNames = genreNames.map { genreTranslation[$0] ?? $0}
                        
                        tvs.combineTMDB[i].results[j].genreNames = genreNames
                    }
                }
                
                DispatchQueue.main.async {
                    self.tvCombineSection = tvs
                    self.reloadData()
                }
            } catch {
                print("❌ Error: \(error)")
            }
        }
    }

    private func getGenresFromHomeSection(for genreIDs: [Int], contentType: ContentType) -> [String] {
        switch contentType {
        case .movie:
            return genreIDs.compactMap { genreID in
                HomeViewController.movieGenres.first { $0.id == genreID }?.name
            }
        case .tv:
            return genreIDs.compactMap { genreID in
                HomeViewController.tvGenres.first {  $0.id == genreID }?.name
            }
        case .people:
            return []
        }
    }
}


// MARK: - Extension
extension SeriesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let selectedMovie = dataSource?.itemIdentifier(for: indexPath.self) else { return }
        
        let contentID = selectedMovie.tvResult.id
        
        let detailVC = DetailViewController(contentID: contentID, contentType: .tv)
        
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
}

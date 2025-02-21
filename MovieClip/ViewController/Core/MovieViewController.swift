//
//  MovieViewController.swift
//  MovieClip
//
//  Created by 권정근 on 2/4/25.
//

import UIKit

class MovieViewController: UIViewController {
    
    // MARK: - Variable
    var combineSection: CombineData = CombineData(combineTMDB: [])
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<TMDBData, MainResults>?
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        // ✅ 네비에기션 타이틀 설정
        navigationItem.title = "Movie"
        navigationController?.navigationBar.prefersLargeTitles = true
        configureNavigationBarAppearance()
        
        setupCollectionView()
        
        fetchMovies()
        createDataSource()
        
        collectionView.delegate = self
    }
    
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
    
    func setupCollectionView() {
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompositonalLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .black
        collectionView.showsVerticalScrollIndicator = false
        view.addSubview(collectionView)
    
        collectionView.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeader.reuseIdentifier)
        
        collectionView.register(TodayCollectionViewCell.self, forCellWithReuseIdentifier: TodayCollectionViewCell.reuseIdentifier)
        collectionView.register(FeaturedCell.self, forCellWithReuseIdentifier: FeaturedCell.reuseIdentifier)
    
    }
    
    func configure<T: SelfConfiguringCell>(_ cellType: T.Type, with model: MainResults, for indexPath: IndexPath) -> T {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellType.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Unable to dequeue \(cellType)")
        }
        cell.configure(with: model)
        return cell
    }
    
    func reloadData() {
        var snapshot = NSDiffableDataSourceSnapshot<TMDBData, MainResults>()
    
        for tmdbData in combineSection.combineTMDB {
           
            snapshot.appendSections([tmdbData])
            snapshot.appendItems(tmdbData.results, toSection: tmdbData)
            
        }
        
        dataSource?.apply(snapshot, animatingDifferences: true)
        
    }
    
    func createDataSource() {
        dataSource = UICollectionViewDiffableDataSource<TMDBData, MainResults>(collectionView: collectionView) {
            collectionView, indexPath, model in
            switch self.combineSection.combineTMDB[indexPath.section].type {
            case .topRatedMovie:
                return self.configure(FeaturedCell.self, with: model, for: indexPath)
            default:
                return self.configure(TodayCollectionViewCell.self, with: model, for: indexPath)
            }
        }
        
        dataSource?.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath in
            guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeader.reuseIdentifier, for: indexPath) as? SectionHeader else { return nil}
            
            guard let firstApp = self?.dataSource?.itemIdentifier(for: indexPath) else { return nil }
            guard let section = self?.dataSource?.snapshot().sectionIdentifier(containingItem: firstApp) else { return nil }
            
            switch section.type {
            case .noewPlayingMovie:
                sectionHeader.title.text = section.type?.rawValue
                sectionHeader.subTitle.text = "상영중인 작품"
            case .popularMovie:
                sectionHeader.title.text = section.type?.rawValue
                sectionHeader.subTitle.text = "선호하는 작품"
            case .topRatedMovie:
                sectionHeader.title.text = section.type?.rawValue
                sectionHeader.subTitle.text = "작품 순위"
            case .upcomingMovie:
                sectionHeader.title.text = section.type?.rawValue
                sectionHeader.subTitle.text = "개봉 예정 작품"
            default:
                return nil
            }
            return sectionHeader
            
        }
    }
    
    func createCompositonalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            
            let section = self.combineSection.combineTMDB[sectionIndex]
            
            switch section.type {
            case .topRatedMovie:
                return self.createMediumTableSection(using: section.results)
                
            default:
                return self.createFeaturedSection(using: section.results)
            }
        }
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20
        layout.configuration = config
        return layout
    }
    
    func createFeaturedSection(using section: [MainResults]) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))

        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5)

        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.93), heightDimension: .estimated(550))
        let layoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: layoutGroupSize, subitems: [layoutItem])

        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        layoutSection.orthogonalScrollingBehavior = .groupPagingCentered
        
        let layoutSectionHeader = createSectionHeader()
        layoutSection.boundarySupplementaryItems = [layoutSectionHeader]
        
        return layoutSection
    }
    
    func createMediumTableSection(using section: [MainResults]) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.25))
        
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5)
        
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.93), heightDimension: .fractionalHeight(0.55))
        let layoutGroup = NSCollectionLayoutGroup.vertical(layoutSize: layoutGroupSize, subitems: [layoutItem])
        
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        layoutSection.orthogonalScrollingBehavior = .groupPagingCentered
        
        let layoutSectionHeader = createSectionHeader()
        layoutSection.boundarySupplementaryItems = [layoutSectionHeader]
        
        return layoutSection
    }
    
    func createSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let layoutSectionHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.93), heightDimension: .estimated(80))
        let layoutSectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: layoutSectionHeaderSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        return layoutSectionHeader
    }
    
    private func fetchMovies() {
        // Task를 사용해 비동기 작업 실행
        Task {
            do {
                let movies = try await NetworkManager.shared.fetchAllMovies()
                
                // UI 업데이트는 메인 스레드에서 실행
                DispatchQueue.main.async {
                    self.combineSection = movies
                    //self.displayMovies(movies)
                    self.reloadData()
                }
            } catch {
                // 에러 처리
                DispatchQueue.main.async {
                    self.showError(error)
                }
            }
        }
    }
    
    private func displayMovies(_ movies: CombineData) {
        // 영화 데이터를 UI에 표시
        movies.combineTMDB.forEach { movie in
            dump(movie)
        }
        /*
        items.forEach { movie in
            print("Title: \(movie.title), Release Date: \(movie.release_date)")
        }
         */
    }
    
    private func showError(_ error: Error) {
        // 에러를 사용자에게 표시 (예: Alert)
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}


extension MovieViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let selectedMovie = dataSource?.itemIdentifier(for: indexPath) else { return }
        
        let contentID = selectedMovie.id
        
        let detailVC = DetailViewController(contentID: contentID, contentType: .movie)
        
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

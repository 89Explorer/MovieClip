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
        
        seriesCollectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompositionalLayout())
        seriesCollectionView.backgroundColor = .black
        seriesCollectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        seriesCollectionView.showsVerticalScrollIndicator = false
        view.addSubview(seriesCollectionView)
        
        seriesCollectionView.register(TvFeaturedCell.self, forCellWithReuseIdentifier: TvFeaturedCell.reuseIdentifier)
        
        fetchTvs()
        createDataSource()
    }
    
    
    // MARK: - Function
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
//            case .airingToday:
//                return self.configure(TvFeaturedCell.self, with: tvTMDBResult, for: indexPath)
//            case .onTheAir:
//                return self.configure(TvOnTheAirCell.self, with: tvTMDBResult, for: indexPath)
//            case .popular:
//                return self.configure(TvPopularCell.self, with: tvTMDBResult, for: indexPath)
//            case .topRated:
//                return self.configure(TvTopRatedCell.self, with: tvTMDBResult, for: indexPath)
            default:
                return self.configure(TvFeaturedCell.self, with: tvTMDBResult, for: indexPath)
            }
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
            default:
                return self.createFeaturedSection(using: section.results)
            }
        }
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20
        layout.configuration = config
        return layout
    }
    
    
    private func createFeaturedSection(using section: [TvTMDBResult]) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5)
        
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.93), heightDimension: .estimated(550))
        
        let layoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: layoutGroupSize, subitems: [layoutItem])
        
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        layoutSection.orthogonalScrollingBehavior = .groupPagingCentered
        return layoutSection
    }
    
    
    /// API 호출을 통해 외부 데이터 가져오기
    private func fetchTvs() {
        Task {
            do {
                let tvs = try await NetworkManager.shared.fetchAllTvs()
                
                DispatchQueue.main.async {
                    self.tvCombineSection = tvs
                    self.reloadData()
                }
            } catch {
                print("❌ Error: \(error)")
            }
        }
    }
}

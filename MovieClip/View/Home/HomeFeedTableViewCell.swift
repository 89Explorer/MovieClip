//
//  HomeFeedTableViewCell.swift
//  MovieClip
//
//  Created by 권정근 on 2/4/25.
//

import UIKit

class HomeFeedTableViewCell: UITableViewCell {
    
    // MARK: - Variable
    static let reuseIdentifier: String = "HomeFeedTableViewCell"
    weak var delegate: HomeFeedTableViewCellDelegate? // ✅ 델리게이트 선언

    /// 테이블뷰의 섹션 인덱스 저장
    var sectionIndex: Int = 0
    
    // MARK: - UI Components
    private let homeCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 5
        layout.itemSize = CGSize(width: 200, height: 350)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    // MARK: - Life Cycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .black
        configureConstraints()
        setupCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    /// 컬렉션뷰 델리게이트 설정
    private func setupCollectionView() {
        homeCollectionView.delegate = self
        homeCollectionView.dataSource = self
        homeCollectionView.register(HomeFeedCollectionViewCell.self, forCellWithReuseIdentifier: HomeFeedCollectionViewCell.reuseIdentifier)
    }
    
    // MARK: - Layout
    /// 제약조건
    private func configureConstraints() {
        contentView.addSubview(homeCollectionView)
        homeCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            
            homeCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            homeCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            homeCollectionView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            homeCollectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            
            homeCollectionView.heightAnchor.constraint(equalToConstant: 350)
            
        ])
    }
}


// Extension
extension HomeFeedTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        // 테이블뷰의 섹션에 해당하는 데이터 가져오기
        let sectionData = HomeViewController.homeSections[sectionIndex]
        switch sectionData {
        case .trendingMovies(let movies):
            return movies.count
        case .trendingTVs(let tvs):
            return tvs.count
//        case .trendingPeoples(let peoples):
//            return peoples.count
       }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeFeedCollectionViewCell.reuseIdentifier, for: indexPath) as? HomeFeedCollectionViewCell else { return UICollectionViewCell() }
        
        // 테이블뷰의 섹션에 해당하는 데이터 가져오기
        let sectionData = HomeViewController.homeSections[sectionIndex]
        switch sectionData {
        case .trendingMovies(let movies):
            let movie = movies[indexPath.item]
            cell.configureCollectionView(movie)
        case .trendingTVs(let tvs):
            let tv = tvs[indexPath.item]
            cell.configureCollectionView(tv)
//        case .trendingPeoples(let peoples):
//            let people = peoples[indexPath.item]
//            cell.configureCollectionView(people)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // ✅ 셀이 눌리는 확인하기 위한 print() 문
        // print("✅ [컬렉션뷰] 선택된 셀 - section: \(sectionIndex), item: \(indexPath.item)")
        delegate?.homeFeedTableViewCellDidSelectItem(self, section: sectionIndex, index: indexPath.item)
    }
}


// MARK: - Protocol
protocol HomeFeedTableViewCellDelegate: AnyObject {
    func homeFeedTableViewCellDidSelectItem(_ cell: HomeFeedTableViewCell, section: Int, index: Int)
}


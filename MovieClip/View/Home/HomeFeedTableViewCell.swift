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
        contentView.backgroundColor = .clear
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
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeFeedCollectionViewCell.reuseIdentifier, for: indexPath) as? HomeFeedCollectionViewCell else { return UICollectionViewCell() }
        
        return cell
    }
}

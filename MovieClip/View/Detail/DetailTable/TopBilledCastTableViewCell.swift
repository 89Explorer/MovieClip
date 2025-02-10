//
//  TopBilledCastTableViewCell.swift
//  MovieClip
//
//  Created by 권정근 on 2/9/25.
//

import UIKit

class TopBilledCastTableViewCell: UITableViewCell {
    
    // MARK: - Variable
    static let reuseIdentifier: String = "TopBilledCastTableViewCell"
    private var castingList: CastingList?

    
    // MARK: - UI Components
    private let topBilledCastCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 150, height: 200)
        layout.minimumLineSpacing = 10
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = true
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    
    // MARK: - Life Cycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = .black
        
        setupCollectionView()
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Function
    private func setupCollectionView() {
        topBilledCastCollectionView.delegate = self
        topBilledCastCollectionView.dataSource = self
        topBilledCastCollectionView.register(CastCollectionViewCell.self, forCellWithReuseIdentifier: CastCollectionViewCell.reuseIdentifier)
    }
    
    
    func configure(with casting: CastingList) {
        self.castingList = casting
        topBilledCastCollectionView.reloadData()   // ✅ 데이터 업데이트 후 컬렉션 뷰 리로드
    }
    
    
    // MARK: - Layout
    private func configureConstraints() {
        contentView.addSubview(topBilledCastCollectionView)
        
        topBilledCastCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            topBilledCastCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            topBilledCastCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            topBilledCastCollectionView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            topBilledCastCollectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            topBilledCastCollectionView.heightAnchor.constraint(equalToConstant: 195)
            
        ])
    }
}


// MARK: - Extension: UICollectionViewDelegate, UICollectionViewDataSource
extension TopBilledCastTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch castingList {
        case .movie(let castInfo):
            return castInfo.cast.count
        case .tv(let castInfo):
            return castInfo.cast.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CastCollectionViewCell.reuseIdentifier, for: indexPath) as? CastCollectionViewCell else { return UICollectionViewCell() }
        
        switch castingList {
        case .movie(let castInfo):
            let castMember = castInfo.cast[indexPath.item]
            cell.configure(with: castMember)
        case .tv(let castInfo):
            let castMember = castInfo.cast[indexPath.item]
            cell.configure(with: castMember)
        default:
            break
        }
        return cell 
    }
}


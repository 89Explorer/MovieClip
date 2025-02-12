//
//  SimilarTableViewCell.swift
//  MovieClip
//
//  Created by 권정근 on 2/11/25.
//

import UIKit

class SimilarTableViewCell: UITableViewCell {
    
    // MARK: - Variable
    static let reuseIdentifier: String = "SimilarTableViewCell"
    
    private var contentSimilarInfo: HomeSection?
    
    weak var delegate: SimilarTableViewDelegate?   // ✅ DetailViewController로 이벤트 전달할 delegate 선언
    
    
    // MARK: - UI Component
    private let similarCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 250, height: 180)  // 기본값: .video 사이즈
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
        similarCollectionView.delegate = self
        similarCollectionView.dataSource = self
        similarCollectionView.register(SimilarCollectionViewCell.self, forCellWithReuseIdentifier: SimilarCollectionViewCell.reuseIdentifier)
    }
    
    func configure(with contents: HomeSection) {
        self.contentSimilarInfo = contents
        similarCollectionView.reloadData()
    }

    
    // MARK: - Layout
    private func configureConstraints() {
        contentView.addSubview(similarCollectionView)
        
        similarCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            similarCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            similarCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            similarCollectionView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            similarCollectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
            
        ])
    }
}


// MARK: - Extension: UICollectionViewDelegate, UICollectionViewDataSource
extension SimilarTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch contentSimilarInfo {
        case .trendingMovies(let movies):
            return movies.count
        case .trendingTVs(let tvs):
            return tvs.count
//        case .trendingPeoples:
//            return 0
        case .none:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SimilarCollectionViewCell.reuseIdentifier, for: indexPath) as? SimilarCollectionViewCell else { return UICollectionViewCell() }
        
        switch contentSimilarInfo {
            
        case .trendingMovies(let movies):
            let movie = movies[indexPath.item]
            cell.configure(with: .movie(movie))
            cell.delegate = self
            
        case .trendingTVs(let tvs):
            let tv = tvs[indexPath.item]
            cell.configure(with: .tv(tv))
            cell.delegate = self
            
//        case .trendingPeoples(_):
//            return UICollectionViewCell()
        case .none:
            return UICollectionViewCell()
        }
        
        return cell
    }
}


// MARK: Extension - SimilarCollectionViewCellDelegate
extension SimilarTableViewCell: SimilarCollectionViewCellDelegate {
    func didTapSimilarImage(with contentID: Int, contentType: ContentType) {
        delegate?.didTapSimilarImage(with: contentID, contentType: contentType)   // ✅ DetailViewController로 이벤트 전달
    }
}



// 📌 유사한 콘텐츠를 위한 Enum 추가
enum SimilarContent {
    case movie(MovieResult)   // 영화 결과
    case tv(TVResult)         // TV 결과
}


protocol SimilarTableViewDelegate: AnyObject {
    func didTapSimilarImage(with contentID: Int, contentType: ContentType)
}



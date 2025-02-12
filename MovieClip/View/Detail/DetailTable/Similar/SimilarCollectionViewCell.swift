//
//  SimilarCollectionViewCell.swift
//  MovieClip
//
//  Created by 권정근 on 2/11/25.
//

import UIKit
import SDWebImage

class SimilarCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Variable
    static let reuseIdentifier = "SimilarCollectionViewCell"
    
    weak var delegate: SimilarCollectionViewCellDelegate?
    private var selectedContentId: Int?    // ✅ 클릭한 영화 또는 TV 경로 저장
    private var selectedContentType: ContentType
    
    
    // MARK: - UI Component
    private let similarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let similarTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.textColor = .white
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()
    
    private let scoreLabel: ScoreLabel = ScoreLabel()
    
    // MARK: - Life Cycle
    override init(frame: CGRect) {
        self.selectedContentType = .movie
        super.init(frame: frame)
        contentView.backgroundColor = .black
        
        
        setupTapGesture()
        
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        similarImageView.image = nil
        similarTitleLabel.text = nil
        selectedContentId = nil
        selectedContentType = .movie
    }
    
    
    // MARK: - Function
    // ✅ 기존 ContentDetail이 아닌 SimilarContent를 사용
    func configure(with content: SimilarContent) {
        switch content {
        case .movie(let movieDetail):
            if let posterPath = movieDetail.backdropPath, !posterPath.isEmpty {
                guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(posterPath)") else { return }
                similarImageView.sd_setImage(with: url, completed: nil)
            } else {
                similarImageView.image = UIImage(systemName: "photo.badge.exclamationmark")
            }
            
            let title = movieDetail.title
            similarTitleLabel.text = title
            
            let score = (movieDetail.voteAverage)
            scoreLabel.configure(with: score != 0 ? Int(score * 10) : 100)
            
            self.selectedContentId = movieDetail.id
            self.selectedContentType = .movie
            
        case .tv(let tvDetail):
            
            if let posterPath = tvDetail.backdropPath, !posterPath.isEmpty {
                guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(posterPath)") else { return }
                similarImageView.sd_setImage(with: url, completed: nil)
            } else {
                similarImageView.image = UIImage(systemName: "photo.badge.exclamationmark")
            }
            
            let name = tvDetail.name
            similarTitleLabel.text = name
            
            let score = (tvDetail.voteAverage)
            scoreLabel.configure(with: score != 0 ? Int(score * 10) : 100)
            
            self.selectedContentId = tvDetail.id
            self.selectedContentType = .tv
        }
        
    }
    
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapImageView))
        similarImageView.isUserInteractionEnabled = true
        similarImageView.addGestureRecognizer(tapGesture)
    }
    
    
    // MARK: - Action
    @objc private func didTapImageView() {
        guard let selectedContentId = selectedContentId else {
            print("❌ selectedContentId is nil")
            return
        }
        
        delegate?.didTapSimilarImage(with: selectedContentId, contentType: selectedContentType)    // ✅ 이벤트를 "SimilarTableViewCell" 전달
    }
    
    
    // MARK: - Layout
    private func configureConstraints() {
        contentView.addSubview(similarImageView)
        contentView.addSubview(similarTitleLabel)
        contentView.addSubview(scoreLabel)
        
        similarImageView.translatesAutoresizingMaskIntoConstraints = false
        similarTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            similarImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            similarImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            similarImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            similarImageView.heightAnchor.constraint(equalToConstant: 150),
            
            similarTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            similarTitleLabel.topAnchor.constraint(equalTo: similarImageView.bottomAnchor, constant: 5),
            similarTitleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            similarTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            
            scoreLabel.leadingAnchor.constraint(equalTo: similarImageView.leadingAnchor, constant: 10),
            scoreLabel.topAnchor.constraint(equalTo: similarImageView.topAnchor, constant: 10),
            scoreLabel.widthAnchor.constraint(equalToConstant: 34),
            scoreLabel.heightAnchor.constraint(equalToConstant: 34)
            
        ])
    }
}


// MARK: - Protocol: SimilarCollectionViewCellDelegate
protocol SimilarCollectionViewCellDelegate: AnyObject {
    func didTapSimilarImage(with contentID: Int, contentType: ContentType)    // 👉 이미지 누르면 contentID 받는 메서드
}

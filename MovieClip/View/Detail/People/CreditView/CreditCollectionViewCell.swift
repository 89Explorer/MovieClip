//
//  CreditCollectionViewCell.swift
//  MovieClip
//
//  Created by 권정근 on 2/17/25.
//

import UIKit

class CreditCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Variable
    static let reuseIdentifier: String = "CreditCollectionViewCell"
    
    private var selectedContentId: Int?    // ✅ 클릭한 영화 또는 TV 경로 저장
    private var selectedContentType: ContentType?
    
    weak var delegate: CreditCollectionViewCellDelegate?
    
    
    // MARK: - UI Component
    private let creditImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let creditTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.textColor = .white
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()
    
    private let scoreLabel: ScoreLabel = ScoreLabel()
    
    
    // MARK: - Init
    override init(frame: CGRect) {
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
        creditImageView.image = nil
        creditTitleLabel.text = nil
        selectedContentId = nil
        selectedContentType = nil
        scoreLabel.text = nil
    }
    
    
    // MARK: - Function
    func configure(with content: CreditInfo) {
        switch content {
        case .movie(let movieDetail):
            if let posterPath = movieDetail.backdropPath, !posterPath.isEmpty {
                guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(posterPath)") else { return }
                creditImageView.sd_setImage(with: url, completed: nil)
            } else {
                creditImageView.image = UIImage(systemName: "photo.badge.exclamationmark")
            }
            
            let title = movieDetail.title
            creditTitleLabel.text = title
            
            let score = (movieDetail.voteAverage)
            scoreLabel.configure(with: score != 0 ? Int(score * 10) : 100)
            
            self.selectedContentId = movieDetail.id
            self.selectedContentType = .movie
            
            
            
        case .tv(let tvDetail):
            
            if let posterPath = tvDetail.backdropPath, !posterPath.isEmpty {
                guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(posterPath)") else { return }
                creditImageView.sd_setImage(with: url, completed: nil)
            } else {
                creditImageView.image = UIImage(systemName: "photo.badge.exclamationmark")
            }
            
            let name = tvDetail.name
            creditTitleLabel.text = name
            
            let score = (tvDetail.voteAverage)
            scoreLabel.configure(with: score != 0 ? Int(score * 10) : 100)
            
            self.selectedContentId = tvDetail.id
            self.selectedContentType = .tv
            
        }
        
    }
    
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapCreditImage))
        creditImageView.isUserInteractionEnabled = true
        creditImageView.addGestureRecognizer(tapGesture)
    }
    
    
    // MARK: - Action
    @objc private func didTapCreditImage() {
        guard let selectedContentId = selectedContentId, let selectedContentType = selectedContentType else {
            print("❌ selectedContentId or selectedContentType is nil")
            return
        }
        delegate?.didTapImage(with: selectedContentId, contentType: selectedContentType)
    }
    
    // MARK: - Layout
    private func configureConstraints() {
        contentView.addSubview(creditImageView)
        contentView.addSubview(creditTitleLabel)
        contentView.addSubview(scoreLabel)
        
        creditImageView.translatesAutoresizingMaskIntoConstraints = false
        creditTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            creditImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            creditImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            creditImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            creditImageView.heightAnchor.constraint(equalToConstant: 150),
            
            creditTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            creditTitleLabel.topAnchor.constraint(equalTo: creditImageView.bottomAnchor, constant: 5),
            creditTitleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            creditTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            
            scoreLabel.leadingAnchor.constraint(equalTo: creditImageView.leadingAnchor, constant: 10),
            scoreLabel.topAnchor.constraint(equalTo: creditImageView.topAnchor, constant: 10),
            scoreLabel.widthAnchor.constraint(equalToConstant: 34),
            scoreLabel.heightAnchor.constraint(equalToConstant: 34)
            
        ])
    }
    
}


// MARK: - Protocol
protocol CreditCollectionViewCellDelegate: AnyObject {
    func didTapImage(with contentID: Int, contentType: ContentType)
}

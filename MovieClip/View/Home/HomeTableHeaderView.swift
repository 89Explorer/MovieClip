//
//  HomeTableHeaderView.swift
//  MovieClip
//
//  Created by 권정근 on 2/4/25.
//

import UIKit

class HomeTableHeaderView: UIView {
    
    // MARK: - Variable
    weak var delegate: HomeTableHeaderviewDelegate?
    private var contentID: Int?
    
    // MARK: - UI Component
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        return imageView
    }()
    
    private let scoreLabel: ScoreLabel = ScoreLabel()
    
    // MARK: - Life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        
        setupTapGesture()
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Function
    // 영화, 티비 데이터를 받아와 UI 구성
    func configure(_ content: MovieResult) {
        
        let score = (content.voteAverage)
        scoreLabel.configure(with: score != 0 ? Int(score * 10) : 100)
    
        if let posterPath = content.posterPath, !posterPath.isEmpty {
            guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(posterPath)") else { return }
            posterImageView.sd_setImage(with: url, completed: nil)
        } else {
            posterImageView.image = UIImage(systemName: "photo.badge.exclamationmark")
        }
        
        self.contentID = content.id
        
    }
    
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapPosterImageView))
        posterImageView.isUserInteractionEnabled = true
        posterImageView.addGestureRecognizer(tapGesture)
    }
    
    
    // MARK: - Action
    @objc private func didTapPosterImageView() {
        guard let contentID = contentID else {
            print("❌ No contentID")
            return
        }
        
        delegate?.didTapHomeTableHeader(contentID: contentID, contentType: .movie)
    }

    // MARK: - Layouts
    private func configureConstraints() {
        addSubview(posterImageView)
        addSubview(scoreLabel)
        
        posterImageView.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            posterImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            posterImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            posterImageView.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            posterImageView.heightAnchor.constraint(equalToConstant: 340),
            
            scoreLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 90),
            scoreLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            scoreLabel.widthAnchor.constraint(equalToConstant: 34),
            scoreLabel.heightAnchor.constraint(equalToConstant: 34)

        ])
    }
}


// MARK: - Protocol
protocol HomeTableHeaderviewDelegate: AnyObject {
    func didTapHomeTableHeader(contentID: Int, contentType: ContentType)
}

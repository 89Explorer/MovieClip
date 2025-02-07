//
//  HomeTableHeaderView.swift
//  MovieClip
//
//  Created by 권정근 on 2/4/25.
//

import UIKit

class HomeTableHeaderView: UIView {
    
    // MARK: - UI Component
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "poster")
        imageView.contentMode = .scaleAspectFit
        imageView.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        return imageView
    }()
    
    private let scoreLabel: ScoreLabel = ScoreLabel()
    
    // MARK: - Life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
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
    
        // ✅ 포스터 설정 (nil 체크)
//        if let posterPath = content.posterPath, !posterPath.isEmpty {
//            guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(posterPath)") else { return }
//            posterImageView.sd_setImage(with: url, completed: nil)
//        } else {
//            posterImageView.image = UIImage(systemName: "photo") // ✅ 기본 이미지
//        }
//        
        let posterPath = content.posterPath
        
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(posterPath)") else { return }
        posterImageView.sd_setImage(with: url, completed: nil)
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
            posterImageView.heightAnchor.constraint(equalToConstant: 350),
            
            scoreLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 90),
            scoreLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            scoreLabel.widthAnchor.constraint(equalToConstant: 34),
            scoreLabel.heightAnchor.constraint(equalToConstant: 34)

        ])
    }
}

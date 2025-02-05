//
//  HomeFeedCollectionViewCell.swift
//  MovieClip
//
//  Created by 권정근 on 2/4/25.
//

import UIKit
import SDWebImage

class HomeFeedCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Variable
    static let reuseIdentifier: String = "HomeFeedCollectionViewCell"
    
    // MARK: - UI Component
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "poster")
        imageView.contentMode = .scaleAspectFill
        imageView.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "캡틴 아메리카"
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .white
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private let genreLabel: UILabel = {
        let label = UILabel()
        label.text = "캡틴 아메리카 영화"
        label.font = .systemFont(ofSize: 12, weight: .bold)
        label.textColor = .white
        label.numberOfLines = 1
        label.textAlignment = .center
        return label
    }()
    
    private let releasedDateLabel: UILabel = {
        let label = UILabel()
        label.text = "1월 25일, 2025년"
        label.font = .systemFont(ofSize: 12, weight: .bold)
        label.textColor = .white
        label.numberOfLines = 1
        label.textAlignment = .center
        return label
    }()
    
    private lazy var totalStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [posterImageView, titleLabel, genreLabel, releasedDateLabel])
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        return stackView
    }()
    
    private let scoreLabel: ScoreLabel = ScoreLabel()
    
    
    // MARK: - Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .clear
        
        // scoreLabel.configure(with: 80)
        
        configureConstraints()
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Functions
    // 개별 데이터 정보를 받아서 UI설정 
    func configureCollectionView(with movie: MovieResult) {
        titleLabel.text = movie.title
        releasedDateLabel.text = formatDateString(movie.releaseDate)
        
        let score = (movie.voteAverage)
        if score != 0 {
            scoreLabel.configure(with: Int(score) * 10)
        } else {
            scoreLabel.configure(with: 100)
        }
        
        let posterPath = movie.posterPath
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(posterPath)") else { return }
        
        posterImageView.sd_setImage(with: url, completed: nil)
    }
    
    func formatDateString(_ dateString: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-M-d"
        inputFormatter.locale = Locale(identifier: "ko_KR")
        
        guard let date = inputFormatter.date(from: dateString) else { return dateString }
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "M월 d일 yyyy년"
        outputFormatter.locale = Locale(identifier: "ko_KR")
        
        return outputFormatter.string(from: date)
    }
    
    
    // MARK: - Layouts
    private func configureConstraints() {
        contentView.addSubview(totalStackView)
        contentView.addSubview(scoreLabel)
        
        totalStackView.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            totalStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            totalStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            totalStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            totalStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),
            
            posterImageView.heightAnchor.constraint(equalToConstant: 280),
            
            scoreLabel.leadingAnchor.constraint(equalTo: totalStackView.leadingAnchor, constant: 10),
            scoreLabel.topAnchor.constraint(equalTo: totalStackView.topAnchor, constant: 15),
            scoreLabel.heightAnchor.constraint(equalToConstant: 34),
            scoreLabel.widthAnchor.constraint(equalToConstant: 34)
            
        ])
        
        totalStackView.setCustomSpacing(5, after: posterImageView)
    }
    
}

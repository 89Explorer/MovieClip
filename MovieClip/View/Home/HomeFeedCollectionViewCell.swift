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
        imageView.clipsToBounds = true
        imageView.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "캡틴 아메리카"
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.textColor = .white
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private let genreLabel: UILabel = {
        let label = UILabel()
        label.text = "캡틴 아메리카 영화"
        label.font = .systemFont(ofSize: 12, weight: .semibold)
        label.textColor = .white
        label.numberOfLines = 1
        label.textAlignment = .center
        return label
    }()
    
    private let releasedDateLabel: UILabel = {
        let label = UILabel()
        label.text = "1월 25일, 2025년"
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .white
        label.numberOfLines = 1
        label.textAlignment = .center
        return label
    }()
    
    private lazy var totalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.alignment = .fill
        stackView.distribution = .fill
        return stackView
    }()
    
    private let scoreLabel: ScoreLabel = ScoreLabel()
    
    
    // MARK: - Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .clear
        
        configureConstraints()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Function
    // 영화 데이터 정보를 받아서 UI설정
    func configureCollectionView(_ movie: MovieResult) {
        // ✅ 기존 View 제거
        removeAllArrangedSubviews()
        toggleScoreLabel(show: true)    // Movie에서는 scoreLabel 존재
        
        releasedDateLabel.text = formatDateString(movie.releaseDate)
        
        let score = (movie.voteAverage)
        scoreLabel.configure(with: score != 0 ? Int(score * 10) : 100)
        
        if let posterPath = movie.posterPath, !posterPath.isEmpty {
            guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(posterPath)") else { return }
            posterImageView.sd_setImage(with: url, completed: nil)
        } else {
            posterImageView.image = UIImage(systemName: "photo.badge.exclamationmark")
        }
    
        // 장르를 " / " 로 구분하여 표시
        genreLabel.text = movie.genreNames?.joined(separator: " / ") ?? "장르 없음"
        
        // ✅ Movie, TV에서는 genreLabel + releasedDateLabel
        totalStackView.addArrangedSubview(releasedDateLabel)
        totalStackView.addArrangedSubview(genreLabel)
        
    }
    
    // TV 데이터 정보를 받아서 UI 설정
    func configureCollectionView(_ tv: TVResult) {
        // ✅ 기존 View 제거
        removeAllArrangedSubviews()
        toggleScoreLabel(show: true)    // TV에서는 scoreLabel 표시
        
        titleLabel.text = tv.name
        releasedDateLabel.text = formatDateString(tv.firstAirDate)
        
        let score = (tv.voteAverage)
        scoreLabel.configure(with: score != 0 ? Int(score * 10) : 100)
        
        if let posterPath = tv.posterPath, !posterPath.isEmpty {
            guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(posterPath)") else { return }
            posterImageView.sd_setImage(with: url, completed: nil)
        } else {
            posterImageView.image = UIImage(systemName: "photo.badge.exclamationmark")
        }
        
        // 장르를 " / " 로 구분하여 표시
        genreLabel.text = tv.genreNames?.joined(separator: " / ") ?? "장르 없음"
        
        // ✅ Movie, TV에서는 genreLabel + releasedDateLabel
        totalStackView.addArrangedSubview(releasedDateLabel)
        totalStackView.addArrangedSubview(genreLabel)
        
    }
    
    // 배우 정보를 받아서 UI 설정
    func configureCollectionView(_ people: PeopleResult) {
        removeAllArrangedSubviews() // ✅ 기존 View 제거
        toggleScoreLabel(show: false)   // people에서는 scoreLabel 제거
        
        titleLabel.text = people.originalName
        genreLabel.text = people.knownForDepartment?.rawValue
        
        // ✅ 프로필 이미지 설정 (nil 또는 빈 문자열 체크)
        if let profilePath = people.profilePath, !profilePath.isEmpty {
            // ✅ 정상적인 URL이 있는 경우 -> 로드
            guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(profilePath)") else { return }
            posterImageView.sd_setImage(with: url, completed: nil)
        } else {
            // ✅ profilePath가 nil 또는 빈 문자열이면 기본 이미지 설정
            posterImageView.image = UIImage(systemName: "person.circle")
        }
        
        // ✅ People에서는 titleLabel만 추가
        totalStackView.addArrangedSubview(titleLabel)
        totalStackView.addArrangedSubview(genreLabel)
        
        
    }
    
    // ✅ 기존 arrangedSubviews 제거하는 메서드
    private func removeAllArrangedSubviews() {
        for view in totalStackView.arrangedSubviews {
            totalStackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
    }
    
    // ✅ show 값이 true일 때 scoreLabel을 추가, false일 때 제거 메서드
    private func toggleScoreLabel(show: Bool) {
        if show {
            
            // ✅ 중복 추가 방지
            if !contentView.subviews.contains(scoreLabel) {
                contentView.addSubview(scoreLabel)
                
                NSLayoutConstraint.activate([
                    
                    scoreLabel.leadingAnchor.constraint(equalTo: posterImageView.leadingAnchor, constant: 10),
                    scoreLabel.topAnchor.constraint(equalTo: posterImageView.topAnchor, constant: 10),
                    scoreLabel.heightAnchor.constraint(equalToConstant: 34),
                    scoreLabel.widthAnchor.constraint(equalToConstant: 34)
                    
                ])
            }
        } else {
            // ✅ 존재하면 제거
            if contentView.subviews.contains(scoreLabel) {
                scoreLabel.removeFromSuperview()
            }
        }
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
        contentView.addSubview(posterImageView)
        contentView.addSubview(totalStackView)
        contentView.addSubview(scoreLabel)
        
        posterImageView.translatesAutoresizingMaskIntoConstraints = false
        totalStackView.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            posterImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            posterImageView.heightAnchor.constraint(equalToConstant: 300),
            
            totalStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            totalStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            totalStackView.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: 5),
            totalStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),
            
            scoreLabel.leadingAnchor.constraint(equalTo: posterImageView.leadingAnchor, constant: 10),
            scoreLabel.topAnchor.constraint(equalTo: posterImageView.topAnchor, constant: 10),
            scoreLabel.heightAnchor.constraint(equalToConstant: 34),
            scoreLabel.widthAnchor.constraint(equalToConstant: 34)
            
        ])
    }
    
}

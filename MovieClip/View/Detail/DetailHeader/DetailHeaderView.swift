//
//  DetailHeaderView.swift
//  MovieClip
//
//  Created by 권정근 on 2/7/25.
//

import UIKit
import SDWebImage

class DetailHeaderView: UIView {
    
    // MARK: - variables
    weak var delegate: DetailHeaderViewDelegate?
    private var selectedTitle: String = ""
    
    
    // MARK: - UI Component
    private let basicView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private let backdropImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.opacity = 0.3
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let posterImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .white
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()
    
    private let releasedDateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .white
        label.numberOfLines = 1
        label.textAlignment = .left
        return label
    }()
    
    private let adultSignImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let genreLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .white
        label.numberOfLines = 2
        label.textAlignment = .left
        return label
    }()
    
    private let runtimeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .white
        label.numberOfLines = 1
        label.textAlignment = .left
        return label
    }()
    
    private let trailerButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.baseBackgroundColor = .systemCyan
        configuration.baseForegroundColor = .white
        configuration.cornerStyle = .medium
        
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        
        configuration.title = "트레일러 재생"
        configuration.titleAlignment = .center
        configuration.attributedTitle?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        
        configuration.image = UIImage(systemName: "play.square")
        configuration.imagePadding = 10
        configuration.imagePlacement = .leading
        
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 15, weight: .bold, scale: .large)
        configuration.preferredSymbolConfigurationForImage = largeConfig
        
        let button = UIButton(configuration: configuration, primaryAction: nil)
        button.addTarget(self, action: #selector(didTapTrailerButton), for: .touchUpInside)
        return button
    }()
    
    private let userScroeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.textColor = .white
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()
    
    private let userVoteCountLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .white
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()
    
    private let myScroeLabel: BasePaddingLabel = {
        let label = BasePaddingLabel(padding: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.text = "내 평점: 🤔"
        label.textColor = .white
        label.numberOfLines = 0
        label.textAlignment = .left
        
        label.layer.borderWidth = 1
        label.layer.borderColor = UIColor.white.cgColor
        label.layer.cornerRadius = 4
        label.layer.masksToBounds = true
        
        return label
    }()
    
    
    // MARK: - Life Cycle
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
    // 🚗 movie 데이터를 받아 UI 전달 메서드
    func configure(_ movie: MovieDetailInfoWelcome, genres: [String]) {
        if let backdropPath = movie.backdropPath {
            guard let url = URL(string: "https://image.tmdb.org/t/p/w500\(backdropPath)") else { return }
            backdropImage.sd_setImage(with: url, completed: nil)
        }
        
        if let posterPath = movie.posterPath {
            guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(posterPath)") else { return }
            posterImage.sd_setImage(with: url, completed: nil)
        }
        
        let title = movie.title
        self.selectedTitle = title
        titleLabel.text = title
        
        let releaseDate = movie.releaseDate
        releasedDateLabel.text = releaseDate
        
        let genres = genres.joined(separator: " / ")
        genreLabel.text = genres
        
        let runTime = movie.runtime
        runtimeLabel.text = "\(runTime)분"
        
        let userScore = String(format: "%.1f", movie.voteAverage)
        userScroeLabel.text = "⭐️ \(userScore)점"
        
        let userVote = movie.voteCount
        userVoteCountLabel.text = "(\(userVote)건)"

    }
    
    // 🚗 tv 데이터를 받아 UI 전달 메서드
    func configure(_ tv: TVDetailInfoWelcome, genres: [String]) {
        if let backdropPath = tv.backdropPath {
            guard let url = URL(string: "https://image.tmdb.org/t/p/w500\(backdropPath)") else { return }
            backdropImage.sd_setImage(with: url, completed: nil)
        }
        
        if let posterPath = tv.posterPath {
            guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(posterPath)") else { return }
            posterImage.sd_setImage(with: url, completed: nil)
        }
        
        let title = tv.name
        self.selectedTitle = title
        titleLabel.text = title
        
        let releaseDate = tv.firstAirDate
        releasedDateLabel.text = releaseDate
        
        let genres = genres.joined(separator: " / ")
        genreLabel.text = genres
        
        let countEpisodes = tv.numberOfEpisodes
        runtimeLabel.text = "에피소드: \(countEpisodes)개"
        
        let userScore = String(format: "%.1f", tv.voteAverage)
        userScroeLabel.text = "⭐️ \(userScore)점"
        
        let userVote = tv.voteCount
        userVoteCountLabel.text = "(\(userVote)건)"
    
    }
    
    // 인물 정보에 대한 함수
    func configure(_ people: PeopleDetailInfoWelcome) {
        backdropImage.backgroundColor = .systemGray
        backdropImage.layer.opacity = 0.3
        
        if let profilePath = people.profilePath {
            guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(profilePath)") else { return }
            posterImage.sd_setImage(with: url, completed: nil)
        }
        
        let name = people.name
        titleLabel.text = name
        
        trailerButton.isHidden = true
        
    }
    
    /// myScoreLabel에 탭 제스처 설정
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapLabel))
        myScroeLabel.isUserInteractionEnabled = true
        myScroeLabel.addGestureRecognizer(tapGesture)
    }
    
    /// myScoreLabel에 slider로 선택된 값 전달
    func updateMyScoreLabel(value: String) {
        myScroeLabel.text = "내 평점: ⭐️ \(value)"
    }
    
    
    // MARK: - Action
    /// trailterButon을 누르면 title 정보 전달
    @objc private func didTapTrailerButton() {
        delegate?.didTapTrailerButton(title: selectedTitle)
    }
    
    
    /// myScroeLabel을 누르면 동작
    @objc private func didTapLabel() {
        delegate?.didTapRating()
    }
    
    
    // MARK: - Layout
    private func configureConstraints() {
        addSubview(basicView)
        basicView.addSubview(backdropImage)
        basicView.addSubview(posterImage)
        basicView.addSubview(titleLabel)
        basicView.addSubview(releasedDateLabel)
        basicView.addSubview(genreLabel)
        basicView.addSubview(runtimeLabel)
        basicView.addSubview(trailerButton)
        basicView.addSubview(userScroeLabel)
        basicView.addSubview(userVoteCountLabel)
        basicView.addSubview(myScroeLabel)
        
        basicView.translatesAutoresizingMaskIntoConstraints = false
        backdropImage.translatesAutoresizingMaskIntoConstraints = false
        posterImage.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        releasedDateLabel.translatesAutoresizingMaskIntoConstraints = false
        genreLabel.translatesAutoresizingMaskIntoConstraints = false
        runtimeLabel.translatesAutoresizingMaskIntoConstraints = false
        trailerButton.translatesAutoresizingMaskIntoConstraints = false
        userScroeLabel.translatesAutoresizingMaskIntoConstraints = false
        userVoteCountLabel.translatesAutoresizingMaskIntoConstraints = false
        myScroeLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            
            basicView.leadingAnchor.constraint(equalTo: leadingAnchor),
            basicView.trailingAnchor.constraint(equalTo: trailingAnchor),
            basicView.topAnchor.constraint(equalTo: topAnchor),
            basicView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            backdropImage.leadingAnchor.constraint(equalTo: basicView.leadingAnchor, constant: 0),
            backdropImage.trailingAnchor.constraint(equalTo: basicView.trailingAnchor, constant: 0),
            backdropImage.topAnchor.constraint(equalTo: basicView.topAnchor, constant: 0),
            backdropImage.heightAnchor.constraint(equalToConstant: 350),
            
            posterImage.leadingAnchor.constraint(equalTo: basicView.leadingAnchor, constant: 20),
            posterImage.widthAnchor.constraint(equalToConstant: 180),
            posterImage.topAnchor.constraint(equalTo: backdropImage.topAnchor, constant: 20),
            posterImage.bottomAnchor.constraint(equalTo: backdropImage.bottomAnchor, constant: -20),
            
            titleLabel.leadingAnchor.constraint(equalTo: posterImage.trailingAnchor, constant: 20),
            titleLabel.topAnchor.constraint(equalTo: posterImage.topAnchor, constant: 5),
            titleLabel.trailingAnchor.constraint(equalTo: backdropImage.trailingAnchor, constant: -10),
            titleLabel.heightAnchor.constraint(equalToConstant: 50),
            
            releasedDateLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor, constant: 0),
            releasedDateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            releasedDateLabel.heightAnchor.constraint(equalToConstant: 20),
            
            genreLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor, constant: 0),
            genreLabel.topAnchor.constraint(equalTo: releasedDateLabel.bottomAnchor, constant: 5),
            genreLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 0),
            genreLabel.heightAnchor.constraint(equalToConstant: 40),
            
            runtimeLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor, constant: 0),
            runtimeLabel.topAnchor.constraint(equalTo: genreLabel.bottomAnchor, constant: 5),
            runtimeLabel.heightAnchor.constraint(equalToConstant: 20),
            
            trailerButton.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor, constant: 0),
            trailerButton.topAnchor.constraint(equalTo: runtimeLabel.bottomAnchor, constant: 5),
            
            userScroeLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor, constant: 0),
            userScroeLabel.topAnchor.constraint(equalTo: trailerButton.bottomAnchor, constant: 10),
            userScroeLabel.heightAnchor.constraint(equalToConstant: 20),
            userScroeLabel.widthAnchor.constraint(equalToConstant: 80),
            
            userVoteCountLabel.leadingAnchor.constraint(equalTo: userScroeLabel.trailingAnchor, constant: 5),
            userVoteCountLabel.topAnchor.constraint(equalTo: userScroeLabel.topAnchor, constant: 0),
            userVoteCountLabel.heightAnchor.constraint(equalToConstant: 20),
            
            myScroeLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor, constant: 0),
            myScroeLabel.topAnchor.constraint(equalTo: userScroeLabel.bottomAnchor, constant: 5),
            
        ])
    }
    
}



// MARK: - Protocol: DetailHeaderViewDelegate
/// detailHeaderView 내 trailterButton 눌렸을 때 동작할 메서드
protocol DetailHeaderViewDelegate: AnyObject {
    func didTapTrailerButton(title: String)
    func didTapRating()
}


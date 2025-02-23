//
//  SearchResultCell.swift
//  MovieClip
//
//  Created by 권정근 on 2/22/25.
//

import UIKit
import Combine

class SearchResultCell: UICollectionViewCell, SelfConfiguringSearchCell {
    
    
    // MARK: - Variable
    static var reuseIdentifier: String = "SearchResultCell"
    private var viewModel: SearchViewModel?
    private var cancellable = Set<AnyCancellable>()
    
    
    // MARk: - UI Component
    private let posterImageView: UIImageView = UIImageView()
    private let mainTitleLabel: UILabel = UILabel()
    private let genreLabel: UILabel = UILabel()
    private let overviewLabel: UILabel = UILabel()
    private let checkButton: UIButton = UIButton()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        // 포스터 설정
        posterImageView.layer.cornerRadius = 5
        posterImageView.layer.masksToBounds = true
        posterImageView.contentMode = .scaleAspectFill
        posterImageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        
        // 제목 설정
        mainTitleLabel.font = UIFont.preferredFont(forTextStyle: .title2)
        mainTitleLabel.textColor = .white
        mainTitleLabel.numberOfLines = 2
        
        
        // 장르 설정
        genreLabel.font = UIFont.preferredFont(forTextStyle: .caption2)
        genreLabel.textColor = .systemGray
        
        
        // 개요 설정
        overviewLabel.font = UIFont.preferredFont(forTextStyle: .caption1)
        overviewLabel.textColor = .white
        overviewLabel.numberOfLines = 2
        
        
        // 버튼 설정
        checkButton.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        checkButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        
        // innerStackView 설정
        let innerStackView: UIStackView = UIStackView(arrangedSubviews: [mainTitleLabel, genreLabel, overviewLabel])
        innerStackView.axis = .vertical
        innerStackView.spacing = 10
        
        
        // outerStackView 설정
        let outerStackView: UIStackView = UIStackView(arrangedSubviews: [posterImageView, innerStackView, checkButton])
        outerStackView.axis = .horizontal
        outerStackView.alignment = .center
        outerStackView.spacing = 10
        
        outerStackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(outerStackView)
        
        
        // 제약조건
        NSLayoutConstraint.activate([
            
            outerStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            outerStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            outerStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            outerStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            posterImageView.widthAnchor.constraint(equalToConstant: 80),
            checkButton.widthAnchor.constraint(equalToConstant: 20)
            
        ])

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Function
    func setViewModel(_ viewModel: SearchViewModel) {
        self.viewModel = viewModel
    }
    
    
    func configure(with data: SearchItem) {
        switch data {
        case .movie(let movie):
            
            // 제목 할당
            let title = movie.title
            mainTitleLabel.text = title
            
            // 장르 할당
            genreLabel.text = movie.genreNames?.joined(separator: " / ") ?? "장르 없음😅"
            
            // 개요 할당
            overviewLabel.text = "번역중 ....."
            
            if let translatedOverview = viewModel?.translatedMovieOverviews[movie.id] {
                overviewLabel.text = translatedOverview
            } else {
                viewModel?.$translatedMovieOverviews
                    .receive(on: DispatchQueue.main)
                    .sink { [weak self] translatedDict in
                        if let translatedText = translatedDict[movie.id] {
                            self?.overviewLabel.text = translatedText
                        }
                    }
                    .store(in: &cancellable)
            }
            
            
            // 이미지 설정
            guard let posterPath = movie.posterPath else { return }
            guard let url = URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)") else { return }
            posterImageView.sd_setImage(with: url, completed: nil)
            
            
//            let genreNames = viewModel?.fetchedGenres[movie.id]
//            genreLabel.text = genreNames?.joined(separator: " / ")
            
            // ✅ 장르 정보를 `viewModel?.fetchedGenres`에서 가져옴
            if let genreNames = viewModel?.fetchedGenres[movie.id] {
                genreLabel.text = genreNames.joined(separator: " / ")
            } else {
                genreLabel.text = "장르 없음😅"
            }
            
            
        case .tv(let tv):
            
            // 제목 할당
            let name = tv.name
            mainTitleLabel.text = name
            
            // 장르 할당
            genreLabel.text = tv.genreNames?.joined(separator: " / ") ?? "장르 없음😅"
            
            // 개요 할당
            overviewLabel.text = "번역중...."
            
            if let translatedOverview = viewModel?.translatedTVOverviews[tv.id] {
                overviewLabel.text = translatedOverview
            } else {
                viewModel?.$translatedTVOverviews
                    .receive(on: DispatchQueue.main)
                    .sink { [weak self] translatedDict in
                        if let translatedText = translatedDict[tv.id] {
                            self?.overviewLabel.text = translatedText
                        }
                    }
                    .store(in: &cancellable)
            }
            
            // 이미지 설정
            guard let posterPath = tv.posterPath else { return }
            guard let url = URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)") else { return }
            posterImageView.sd_setImage(with: url, completed: nil)
            
//            let genreNames = viewModel?.fetchedGenres[tv.id]
//            genreLabel.text = genreNames?.joined(separator: " / ")
            
            // ✅ 장르 정보를 `viewModel?.fetchedGenres`에서 가져옴
            if let genreNames = viewModel?.fetchedGenres[tv.id] {
                genreLabel.text = genreNames.joined(separator: " / ")
            } else {
                genreLabel.text = "장르 없음😅"
            }
            
            
        case .people(let person):
            
            // 이름 할당
            let name = person.name
            mainTitleLabel.text = name
            
            // 직업 할당
            let job = person.knownForDepartment?.rawValue
            genreLabel.text = job
 
            // 배우이미지 할당
            guard let posterPath = person.profilePath else { return }
            guard let url = URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)") else { return }
            posterImageView.sd_setImage(with: url, completed: nil)
        
        }
    }
}

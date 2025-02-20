//
//  TVMediumCell.swift
//  MovieClip
//
//  Created by 권정근 on 2/20/25.
//

import UIKit
import SDWebImage

class TVMediumCell: UICollectionViewCell, SelfConfiguringTVCell {
    
    // MARK: - Variable
    static var reuseIdentifier: String = "TVMediumCell"
    
    
    // MARK: - UI Component
    private let titleLabel: UILabel = UILabel()
    private let genreLabel: UILabel = UILabel()
    private let voteLabel: UILabel = UILabel()
    private let posterImageView: UIImageView = UIImageView()
    private let checkButton: UIButton = UIButton()
        
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // 제목 설정
        titleLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        titleLabel.textColor = .white
        
        
        // 장르 설정
        genreLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
        genreLabel.textColor = .white
        
        
        // 평점 설정
        voteLabel.font = UIFont.preferredFont(forTextStyle: .caption2)
        voteLabel.textColor = .systemMint
        
        
        // 포스터 이미지 설정
        posterImageView.layer.cornerRadius = 10
        posterImageView.layer.masksToBounds = true
        posterImageView.contentMode = .scaleAspectFit
        posterImageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        
        // 버튼 설정
        checkButton.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        checkButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        
        // 텍스트 스택뷰
        let innerStackView = UIStackView(arrangedSubviews: [titleLabel, genreLabel, voteLabel])
        innerStackView.axis = .vertical
        innerStackView.spacing = 5
        
        
        // 전체 스택뷰
        let outerStackView = UIStackView(arrangedSubviews: [posterImageView, innerStackView, checkButton])
        outerStackView.axis = .horizontal
        outerStackView.alignment = .center
        outerStackView.spacing = 5
        
        outerStackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(outerStackView)
        
        
        // 제약 조건
        NSLayoutConstraint.activate([
            
            outerStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            outerStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            outerStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            outerStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            posterImageView.widthAnchor.constraint(equalToConstant: 60),
            
            checkButton.widthAnchor.constraint(equalToConstant: 20)
            
        ])
    
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func configure(with data: TvTMDBResult) {
        // 제목
        let title = data.name
        titleLabel.text = title
        
        // 장르
        let genre = data.genreNames?.joined(separator: " / ")
        genreLabel.text = genre
        
        // 평점
        let voteAverage = data.voteAverage
        
        if voteAverage > 0 {
            let roundedAverage = String(format: "%.1f", voteAverage)
            voteLabel.text = "평점: \(roundedAverage)"
        } else {
            voteLabel.text = "평점: 0.0"
        }
        
        let posterPath = data.posterPath
        
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)") else { return }
        
        posterImageView.sd_setImage(with: url, completed: nil)
    }
    
    
}

//
//  TvFeaturedCell.swift
//  MovieClip
//
//  Created by 권정근 on 2/20/25.
//

import UIKit
import SDWebImage

class TvFeaturedCell: UICollectionViewCell, SelfConfiguringTVCell {
    
    // MARK: - Variable
    static var reuseIdentifier: String = "TvFeaturedCell"
    
    
    // MARK: - UI Component
    private let voteLabel: UILabel = UILabel()
    private let titleLabel: UILabel = UILabel()
    private let genreLabel: UILabel = UILabel()
    private let tvImageView: UIImageView = UIImageView()
    

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .black
        setupUI()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Function
    func setupUI() {
        
        let seprator = UIView(frame: .zero)
        seprator.translatesAutoresizingMaskIntoConstraints = false
        seprator.backgroundColor = .systemGray
        
        // 평점 라벨 UI 설정
        voteLabel.font = UIFontMetrics.default.scaledFont(for: UIFont.systemFont(ofSize: 12, weight: .bold))
        voteLabel.textColor = .systemRed
        
        
        // 제목 라벨 UI 설정
        titleLabel.font = UIFontMetrics.default.scaledFont(for: UIFont.systemFont(ofSize: 16, weight: .bold))
        titleLabel.textColor = .white
        
        
        // 장르 라벨 UI 설정
        genreLabel.font = UIFontMetrics.default.scaledFont(for: UIFont.systemFont(ofSize: 12, weight: .bold))
        genreLabel.textColor = .systemGray
        
        
        // 포스터 이미지 UI 설정
        tvImageView.layer.cornerRadius = 10
        tvImageView.layer.masksToBounds = true
        tvImageView.contentMode = .scaleAspectFit
        
        
        // 스택뷰 설정
        let stackView = UIStackView(arrangedSubviews: [seprator, voteLabel, titleLabel, genreLabel, tvImageView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        
        
        // 제약조건 설정
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            
            seprator.heightAnchor.constraint(equalToConstant: 1),
            
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
            
        ])
        
        stackView.setCustomSpacing(10, after: seprator)
        stackView.setCustomSpacing(10, after: genreLabel)
    }
    
    
    func configure(with data: TvTMDBResult) {
        
        // 평점 할당
        let voteAverage = data.voteAverage
        
        if voteAverage > 0 {
            let roundedAverage = String(format: "%.1f", voteAverage)
            voteLabel.text = "평점: \(roundedAverage)"
        } else {
            voteLabel.text = "평점: 0.0"
        }
        
        // 제목 할당
        let title = data.name
        titleLabel.text = title
        
        // 장르 할당  (" / " 로 구분하여 표시)
        genreLabel.text = data.genreNames?.joined(separator: " / ") ?? "장르 없음"
        
        let posterPath = data.posterPath
        
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)") else { return }
        
        tvImageView.sd_setImage(with: url, completed: nil)

    }
}

//
//  TVSmallCell.swift
//  MovieClip
//
//  Created by 권정근 on 2/20/25.
//

import UIKit

class TVSmallCell: UICollectionViewCell, SelfConfiguringTVCell {
    
    
    // MARK: - Variable
    static var reuseIdentifier: String = "UICollectionViewCell"
    
    
    // MARK: - UI Component
    private let mainTitleLabel: UILabel = UILabel()
    private let posterImageView: UIImageView = UIImageView()
    
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // 제목 설정
        mainTitleLabel.font = UIFont.preferredFont(forTextStyle: .title2)
        mainTitleLabel.textColor = .white
        
        
        // 이미지 설정
        posterImageView.layer.cornerRadius = 5
        posterImageView.clipsToBounds = true
        posterImageView.contentMode = .scaleAspectFit
        
        
        // 스택뷰 설정
        let stackView = UIStackView(arrangedSubviews: [posterImageView, mainTitleLabel])
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            posterImageView.widthAnchor.constraint(equalToConstant: 60)
            
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

    func configure(with data: TvTMDBResult) {
        let title = data.name
        mainTitleLabel.text = title
        
        let posterPath = data.posterPath
        
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)") else { return }
        
        posterImageView.sd_setImage(with: url, completed: nil)
    }
}

//
//  HomeFeedCollectionViewCell.swift
//  MovieClip
//
//  Created by 권정근 on 2/4/25.
//

import UIKit

class HomeFeedCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Variable
    static let reuseIdentifier: String = "HomeFeedCollectionViewCell"
    
    // MARK: - UI Component
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "poster")
        imageView.contentMode = .scaleAspectFit
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
        //        stackView.setCustomSpacing(1, after: posterImageView)
        return stackView
    }()
    
    
    // MARK: - Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layouts
    private func configureConstraints() {
        contentView.addSubview(totalStackView)
        totalStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            totalStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            totalStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            totalStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            totalStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),
            
            posterImageView.heightAnchor.constraint(equalToConstant: 300)
            
        ])
        
        totalStackView.setCustomSpacing(5, after: posterImageView)
    }
    
}

//
//  FeaturedCell.swift
//  MovieClip
//
//  Created by 권정근 on 2/18/25.
//

import UIKit
import SDWebImage


class FeaturedCell: UICollectionViewCell, SelfConfiguringCell {
    
    // MAKR: - Variable
    static var reuseIdentifier: String = "FeaturedCell"
    
    
    // MARK: - UI Component
    private let titleLabel = UILabel()
    private let overviewLabel = UILabel()
    let imageView = UIImageView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 80, height: 80)))
    let moveButton = UIButton(type: .custom)
    
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .black
        
        titleLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        titleLabel.textColor = .white
        
        overviewLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
        overviewLabel.textColor = .white
        overviewLabel.numberOfLines = 2
        
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        moveButton.setImage(UIImage(systemName: "arrowtriangle.right.square.fill"), for: .normal)
        
        moveButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        let innerStackView = UIStackView(arrangedSubviews: [titleLabel, overviewLabel])
        innerStackView.axis = .vertical
        innerStackView.spacing = 5
        
        let outerStackView = UIStackView(arrangedSubviews: [imageView, innerStackView, moveButton])
        outerStackView.translatesAutoresizingMaskIntoConstraints = false
        outerStackView.alignment = .center
        outerStackView.spacing = 5
        outerStackView.axis = .horizontal
        contentView.addSubview(outerStackView)
        
        NSLayoutConstraint.activate([
            
            outerStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            outerStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            outerStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            
            imageView.heightAnchor.constraint(equalToConstant: 80),
            imageView.widthAnchor.constraint(equalToConstant: 60),
            
            moveButton.heightAnchor.constraint(equalToConstant: 20),
            moveButton.widthAnchor.constraint(equalToConstant: 20)
            
            
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Function
    func configure(with data: MainResults) {
        titleLabel.text = data.title
        overviewLabel.text = data.overview
        
        if let posterPath = data.poster_path,
           let url = URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)") {
            imageView.sd_setImage(with: url, completed: nil)
        }
        
        // 비동기적으로 번역 수행
    }
}

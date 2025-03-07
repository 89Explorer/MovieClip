//
//  ReviewOptionCell.swift
//  MovieClip
//
//  Created by 권정근 on 3/6/25.
//

import UIKit

class ReviewOptionCell: UICollectionViewCell, SelfConfiguringReviewCell {
    
    // MARK: - Variable
    static var reuseIdentifier: String = "ReviewOptionCell"
    
    weak var delegate: ReviewOptionCellDelegate?
    
    private var optionType: ReviewOptionType? // 기본값
    
    
    // MARK: - UI Component
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .white
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .white
        return label
    }()
    
    private let valueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .white
        return label
    }()
    
    private let chevronImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "chevron.right"))
        imageView.tintColor = .white
        return imageView
    }()
    
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .black
        setupUI()
        setupGesture()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func configure(with item: ReviewSectionItem) {
        if case .options(let reviewOptionType, let string) = item {
            optionType = reviewOptionType
            titleLabel.text = string
            
            switch optionType {
            case .date(let date):
                iconImageView.image = UIImage(systemName: "calendar")
                valueLabel.text = formattedDate(date)
            case .rating(let double):
                iconImageView.image = UIImage(systemName: "star.fill")
                valueLabel.text = ratingString(double)
            case nil:
                break
            }
        }
    }
    
    
    private func setupGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapCell))
        contentView.addGestureRecognizer(tapGesture)
    }
    
    
    // MARK: - Action
    @objc private func didTapCell() {
        if let optionType = optionType {
            delegate?.didTapOption(optionType)
        }
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 M월 d일"
        return formatter.string(from: date)
    }
    
    private func ratingString(_ rating: Double) -> String {
        let fullStar = Int(rating)
        let emptyStars = 5 - fullStar
        return String(repeating: "🌟", count: fullStar) + String(repeating: "☆", count: emptyStars)
    }
    
    
    // MARK: - Layout
    private func setupUI() {
        contentView.addSubview(iconImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(valueLabel)
        contentView.addSubview(chevronImageView)
        
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        chevronImageView.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
            
            iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            iconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 24),
            iconImageView.heightAnchor.constraint(equalToConstant: 24),
            
            titleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 10),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            chevronImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            chevronImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            chevronImageView.widthAnchor.constraint(equalToConstant: 10),
            chevronImageView.heightAnchor.constraint(equalToConstant: 16),
            
            valueLabel.trailingAnchor.constraint(equalTo: chevronImageView.leadingAnchor, constant: -10),
            valueLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
            
        ])
        
    }
    
    
}


// MARK: - Protocol
protocol ReviewOptionCellDelegate: AnyObject {
    func didTapOption(_ type: ReviewOptionType)
}



//
//  TitleTableCell.swift
//  MovieClip
//
//  Created by 권정근 on 3/11/25.
//

import UIKit

class TitleTableCell: UITableViewCell {
    
    static let reuseIdentifier: String = "TitleTableCell"
    
    private let titleLabel: UILabel = UILabel()
    private let ratingLabel: UILabel = UILabel()
    private let createOnLabel: UILabel = UILabel()
    private var innerStackView: UIStackView = UIStackView()
    private var totalStackView: UIStackView = UIStackView()
    
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = .white
        
        titleLabel.font = .systemFont(ofSize: 24, weight: .bold)
        titleLabel.textColor = .black
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .left

        ratingLabel.font = .systemFont(ofSize: 18, weight: .regular)
        ratingLabel.numberOfLines = 1
        
        createOnLabel.font = .systemFont(ofSize: 18, weight: .regular)
        createOnLabel.textColor = .black
        createOnLabel.numberOfLines = 1
        
        
        innerStackView.addArrangedSubview(createOnLabel)
        innerStackView.addArrangedSubview(ratingLabel)
        innerStackView.axis = .horizontal
        innerStackView.spacing = 10
        innerStackView.distribution = .fill
        
        totalStackView.addArrangedSubview(titleLabel)
        totalStackView.addArrangedSubview(innerStackView)
        totalStackView.axis = .vertical
        totalStackView.distribution = .fill
        totalStackView.spacing = 5
        
        contentView.addSubview(totalStackView)
        totalStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            totalStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            totalStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            totalStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            totalStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
            
        ])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configure(reviewItem: ReviewItem) {
        titleLabel.text = reviewItem.content.reviewTitle
        createOnLabel.text = formattedDate(reviewItem.date)
        ratingLabel.text = ratingString(reviewItem.rating)
        
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
}

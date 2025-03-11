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
        
        contentView.backgroundColor = .black
        
        titleLabel.font = .systemFont(ofSize: 18, weight: .bold)
        titleLabel.textColor = .black
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .left

        ratingLabel.font = .systemFont(ofSize: 14, weight: .regular)
        ratingLabel.numberOfLines = 1
        
        createOnLabel.font = .systemFont(ofSize: 14, weight: .regular)
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
        totalStackView.spacing = 10
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configure(reviewItem: ReviewItem) {
        
    }
    
}

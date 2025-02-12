//
//  OverviewTableViewCell.swift
//  MovieClip
//
//  Created by 권정근 on 2/9/25.
//

import UIKit

class OverviewTableViewCell: UITableViewCell {
    
    
    // MARK: - Variable
    static let reuseIdentifier: String = "OverviewTableViewCell"
    
    
    // MARK: - UI Component
    private let overviewLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.numberOfLines = 0
        label.textColor = .white
        return label
    }()
    
    
    // MARK: - Life Cycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .black
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Function
    func configure(with content: ContentDetail) {
        switch content {
        case .movie(let movieDetail):
            overviewLabel.text = movieDetail.overview
        case .tv(let tvDetail):
            overviewLabel.text = tvDetail.overview
        case .people(let peopleDetail):
            overviewLabel.text = peopleDetail.biography
        }
    }
    
    
    // MARK: - Layout
    private func configureConstraints() {
        contentView.addSubview(overviewLabel)
        
        overviewLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            overviewLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            overviewLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            overviewLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            overviewLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
            
        ])
    }
}

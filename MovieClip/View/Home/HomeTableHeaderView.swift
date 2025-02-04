//
//  HomeTableHeaderView.swift
//  MovieClip
//
//  Created by 권정근 on 2/4/25.
//

import UIKit

class HomeTableHeaderView: UIView {
    
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
        return stackView
    }()
    
    private let scoreLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.textColor = .white
        label.backgroundColor = .black
        label.layer.cornerRadius = 20
        label.clipsToBounds = true
        
        // ✅ "55%"에서 "%"만 크기 줄이기
        let fullText = "55%"
        let attributedString = NSMutableAttributedString(string: fullText)
        
        // "%"만 작은 크기로 변경
        let smallerFont = UIFont.systemFont(ofSize: 10, weight: .bold) // % 크기 줄이기
        attributedString.addAttribute(.font, value: smallerFont, range: NSRange(location: 2, length: 1)) // "55%" 중 "%"의 위치 변경
        
        label.attributedText = attributedString
        return label
    }()
    
    
    // MARK: - Life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .black
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Layouts
    private func configureConstraints() {
        
        addSubview(totalStackView)
        addSubview(scoreLabel)
        
        totalStackView.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            totalStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            totalStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            totalStackView.topAnchor.constraint(equalTo: topAnchor),
            totalStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
        
            posterImageView.heightAnchor.constraint(equalToConstant: 350),
            
            scoreLabel.leadingAnchor.constraint(equalTo: totalStackView.leadingAnchor, constant: 85),
            scoreLabel.bottomAnchor.constraint(equalTo: totalStackView.topAnchor, constant: 50),
            scoreLabel.heightAnchor.constraint(equalToConstant: 40),
            scoreLabel.widthAnchor.constraint(equalToConstant: 40)
            
        ])
    }
    
}

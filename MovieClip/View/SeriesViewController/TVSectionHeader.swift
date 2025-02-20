//
//  TVSectionHeader.swift
//  MovieClip
//
//  Created by 권정근 on 2/20/25.
//

import UIKit

class TVSectionHeader: UICollectionReusableView {
    
    // MARK: - Variable
    static let reuseIdentifier: String = "TVSectionHeader"
    
    
    // MARK: - UI Component
    private let mainTitleLabel: UILabel = UILabel()
    private let subTitleLabel: UILabel = UILabel()
    
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .black
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Function
    private func setupUI() {
        // 구분선 설정
        let seperator = UIView(frame: .zero)
        seperator.translatesAutoresizingMaskIntoConstraints = false
        seperator.backgroundColor = .systemBlue
        
        
        // 제목 설정
        mainTitleLabel.font = UIFont.preferredFont(forTextStyle: .title1)
        mainTitleLabel.textColor = .white
        
        
        // 부제목 설정
        subTitleLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
        subTitleLabel.textColor = .systemGray
        
        
        // 스택뷰 설정
        let stackView = UIStackView(arrangedSubviews: [seperator, mainTitleLabel, subTitleLabel])
        stackView.axis = .vertical
        
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            seperator.heightAnchor.constraint(equalToConstant: 1),
            
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
            
        ])
        
        stackView.setCustomSpacing(10, after: seperator)
        
    }
    
    
    func configure(with main: String, sub: String) {
        mainTitleLabel.text = main
        subTitleLabel.text = sub
    }
    
        
}

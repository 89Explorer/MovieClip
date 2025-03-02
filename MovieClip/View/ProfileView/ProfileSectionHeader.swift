//
//  ProfileSectionHeader.swift
//  MovieClip
//
//  Created by 권정근 on 3/2/25.
//

import UIKit

class ProfileSectionHeader: UICollectionReusableView {
    
    // MARK: - Variable
    static let reuseIdentifier: String = "ProfileSectionHeader"
    
    
    // MARK: - UI Component
    private let mainTitleLabel: UILabel = UILabel()
    
    
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
    func configure(with main: String) {
        mainTitleLabel.text = main
    }
    
    private func setupUI() {
        mainTitleLabel.font = .systemFont(ofSize: 26, weight: .bold)
        mainTitleLabel.textColor = .white
        mainTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(mainTitleLabel)
        
        NSLayoutConstraint.activate([
            
            mainTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            mainTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            mainTitleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            mainTitleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5)
            
        ])
    }
    
}

//
//  SearchFooterView.swift
//  MovieClip
//
//  Created by 권정근 on 2/22/25.
//

import UIKit

class SearchFooterView: UICollectionReusableView {
        
    // MARK: - Variable
    static let reuseIdentifier: String = "SearchFooterView"
    private var loadMoreAction: (() -> Void)?
    
    
    // MARK: - UI Component
    let moreButton: UIButton = UIButton(type: .system)
    
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        moreButton.setTitle("더보기", for: .normal)
        moreButton.backgroundColor = .systemBlue
        moreButton.setTitleColor(.white, for: .normal)
        moreButton.layer.cornerRadius = 10
        
        addSubview(moreButton)
        moreButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            moreButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            moreButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            moreButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            moreButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            moreButton.heightAnchor.constraint(equalToConstant: 40)
            
        ])
        
        moreButton.addTarget(self, action: #selector(loadMoreTapped), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with title: String, loadMoreAction: @escaping () -> Void) {
        self.loadMoreAction = loadMoreAction
        moreButton.setTitle(title, for: .normal)
    }
    
    @objc private func loadMoreTapped() {
        loadMoreAction?()
    }
    
}

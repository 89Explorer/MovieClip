//
//  SearchSectionHeader.swift
//  MovieClip
//
//  Created by 권정근 on 2/22/25.
//

import UIKit
import Combine

class SearchSectionHeader: UICollectionReusableView {
    
    // MARK: - Variable
    static let reuseIdentifier: String = "SearchSectionHeader"
    private var viewModel: SearchViewModel?
    private var cancellabel = Set<AnyCancellable>()
    
    
    // MARK: - UI Component
    private let titlelabel: UILabel = UILabel()
    private let seperator: UIView = UIView()
    
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        titlelabel.font = UIFont.preferredFont(forTextStyle: .title3)
        titlelabel.textColor = .white
        
        addSubview(titlelabel)
        titlelabel.translatesAutoresizingMaskIntoConstraints = false
        
        seperator.backgroundColor = .white
        addSubview(seperator)
        seperator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            titlelabel.topAnchor.constraint(equalTo: topAnchor, constant: 2),
            titlelabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            titlelabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            seperator.leadingAnchor.constraint(equalTo: titlelabel.leadingAnchor),
            seperator.trailingAnchor.constraint(equalTo: titlelabel.trailingAnchor),
            seperator.topAnchor.constraint(equalTo: titlelabel.bottomAnchor),
            seperator.heightAnchor.constraint(equalToConstant: 1)
            
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Function
    func configure(with title: String) {
        titlelabel.text = title
    }
    
}


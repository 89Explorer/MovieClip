//
//  ContentTableCell.swift
//  MovieClip
//
//  Created by 권정근 on 3/11/25.
//

import UIKit

class ContentTableCell: UITableViewCell {
    
    static let reuseIdentifier: String = "ContentTableCell"
    
    private let contentTextView: UITextView = UITextView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .white
        
        contentTextView.font = .systemFont(ofSize: 20, weight: .bold)
        contentTextView.textColor = .black
        contentTextView.isEditable = false
        contentTextView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        contentView.addSubview(contentTextView)
        contentTextView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            contentTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            contentTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            contentTextView.topAnchor.constraint(equalTo: contentView.topAnchor),
            contentTextView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
            
        ])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(reviewItem: ReviewItem) {
        contentTextView.text = reviewItem.content.reviewContent
    }
    
}

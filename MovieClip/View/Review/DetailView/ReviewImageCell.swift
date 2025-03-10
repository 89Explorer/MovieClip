//
//  ReviewImageCell.swift
//  MovieClip
//
//  Created by 권정근 on 3/10/25.
//

import UIKit

class ReviewImageCell: UICollectionViewCell {
    
    static let reuseIdentifier: String = "ReviewImageCell"
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
            
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configure(imageURL: String) {
        DispatchQueue.main.async {
            let url = URL(string: imageURL)
            self.imageView.sd_setImage(with: url)
        }

    }
    
}

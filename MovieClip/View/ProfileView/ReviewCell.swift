//
//  ReviewCell.swift
//  MovieClip
//
//  Created by 권정근 on 3/9/25.
//

import UIKit
import SDWebImage


class ReviewCell: UICollectionViewCell, SelfConfiguringProfileCell {
    static var reuseIdentifier: String = "ReviewCell"
    
    private var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "poster")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 5
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configure(with data: ProfileItem) {
        switch data {
        case .review(let reviews):
            let firstImageURL = reviews.photos[0]
            let url = URL(string: firstImageURL)
            
            imageView.sd_setImage(with: url)
        case .profile(_):
            break

        }
    }
}
